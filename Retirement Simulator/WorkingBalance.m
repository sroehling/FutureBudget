//
//  WorkingBalance.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingBalance.h"
#import "SharedAppValues.h"
#import "DateHelper.h"
#import "BalanceAdjustment.h"
#import "NumberHelper.h"


@implementation WorkingBalance

@synthesize balanceStartDate;
@synthesize currentBalance;
@synthesize startingBalance;
@synthesize currentBalanceDate;

- (id) initWithStartingBalance:(double)theStartBalance 
	andStartDate:(NSDate*)theStartDate
{
	self = [super init];
	if(self)
	{
		self.balanceStartDate = theStartDate;
		//[DateHelper beginningOfDay:[SharedAppValues singleton].simStartDate];
		startingBalance = theStartBalance;
		
		[self resetCurrentBalance];
	}
	return self;
}

- (id) init
{
	assert(0); // must call initWithStartDate
}

- (void) resetCurrentBalance
{
	currentBalance = startingBalance;
	self.currentBalanceDate = self.balanceStartDate;
}

- (void) dealloc
{
	[super dealloc];
	[balanceStartDate release];
}

- (void)advanceCurrentBalanceToDate:(NSDate*)newDate
{
	assert(newDate != nil);
	assert([DateHelper dateIsEqualOrLater:newDate otherDate:self.currentBalanceDate]);
	self.currentBalanceDate = newDate;
}

- (void) incrementBalance:(double)amount asOfDate:(NSDate*)newDate
{
	[self advanceCurrentBalanceToDate:newDate];

	assert(amount >= 0.0);
	currentBalance += amount;

	[self logBalance];

}

- (void) decrementBalance:(double)amount asOfDate:(NSDate*)newDate
{
	[self advanceCurrentBalanceToDate:newDate];
	
	assert(amount >= 0.0);	
	currentBalance -= amount;
	
	[self logBalance];
}

- (BalanceAdjustment*)createBalanceAdjustmentForWithdrawAmount:(double)theAmount
{
	if([self doTaxWithdrawals])
	{
		return [[[BalanceAdjustment alloc] 
			initWithTaxFreeAmount:0.0 andTaxableAmount:theAmount] autorelease];
	}
	else
	{
		return [[[BalanceAdjustment alloc] 
			initWithTaxFreeAmount:theAmount andTaxableAmount:0.0] autorelease];
	}
}

- (BalanceAdjustment*) decrementAvailableBalance:(double)amount asOfDate:(NSDate*)newDate
{
	[self advanceCurrentBalanceToDate:newDate];
	
	assert(amount >= 0.0);	

	if(currentBalance > 0.0)
	{
		if(amount <= currentBalance)
		{
			currentBalance -= amount;
			return [self createBalanceAdjustmentForWithdrawAmount:amount];
		}
		else
		{
			double availableAmount = currentBalance;
			currentBalance = 0.0;
			return [self createBalanceAdjustmentForWithdrawAmount:availableAmount];
		}
	}
	else
	{	
		return [self createBalanceAdjustmentForWithdrawAmount:0.0];
	}

}


- (void)carryBalanceForward:(NSDate*)newStartDate
{
	assert(newStartDate != nil);
	assert(newStartDate == [self.currentBalanceDate laterDate:newStartDate]);
	self.balanceStartDate = newStartDate;
	self.currentBalanceDate = newStartDate;
}

- (bool)doTaxWithdrawals
{
	assert(0); // must be overridden
	return FALSE;
}


- (NSString*)balanceName
{
	assert(0); // must be overridden
	return nil;
}

- (void)logBalance
{
		NSString *currentBalCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.currentBalance]];
		NSLog(@"Working balance: %@ %@",self.balanceName,currentBalCurrency);

}


@end
