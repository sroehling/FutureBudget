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
#import "WorkingBalanceAdjustment.h"


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

- (BalanceAdjustment*)advanceCurrentBalanceToDate:(NSDate*)newDate
{
	assert(0); // must be overridden
	return nil;
}


- (BalanceAdjustment*)carryBalanceForward:(NSDate*)newStartDate
{
	assert(newStartDate != nil);
	assert([DateHelper dateIsEqualOrLater:newStartDate otherDate:self.currentBalanceDate]);
	
	BalanceAdjustment *interest = [self advanceCurrentBalanceToDate:newStartDate];
	
	startingBalance = self.currentBalance;
	self.balanceStartDate = newStartDate;
	
	return interest;
}


- (BalanceAdjustment*) incrementBalance:(double)amount asOfDate:(NSDate*)newDate
{
	BalanceAdjustment *interest = [self advanceCurrentBalanceToDate:newDate];

	assert(amount >= 0.0);
	currentBalance += amount;

	[self logBalance];
	return interest;

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

- (WorkingBalanceAdjustment*) decrementAvailableBalance:(double)amount asOfDate:(NSDate*)newDate
{
	BalanceAdjustment *interestAmount = [self advanceCurrentBalanceToDate:newDate];
	
	assert(amount >= 0.0);	

	BalanceAdjustment *decrementAmount;
	if(currentBalance > 0.0)
	{
		if(amount <= currentBalance)
		{
			currentBalance -= amount;
			decrementAmount =  [self createBalanceAdjustmentForWithdrawAmount:amount];
		}
		else
		{
			double availableAmount = currentBalance;
			currentBalance = 0.0;
			decrementAmount = [self createBalanceAdjustmentForWithdrawAmount:availableAmount];
		}
	}
	else
	{	
		decrementAmount = [self createBalanceAdjustmentForWithdrawAmount:0.0];
	}
	
	return [[[WorkingBalanceAdjustment alloc] initWithBalanceAdjustment:decrementAmount 
		andInterestAdjustment:interestAmount] autorelease];

}



- (bool)doTaxWithdrawals
{
	assert(0); // must be overridden
	return FALSE;
}


- (bool)doTaxInterest
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