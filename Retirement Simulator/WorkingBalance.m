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


NSString * const WORKING_BALANCE_WITHDRAWAL_PRIORITY_KEY = @"withdrawPriority";

@implementation WorkingBalance

@synthesize balanceStartDate;
@synthesize currentBalance;
@synthesize startingBalance;
@synthesize currentBalanceDate;
@synthesize withdrawPriority;
@synthesize deferWithdrawalsUntil;

- (id) initWithStartingBalance:(double)theStartBalance 
	andStartDate:(NSDate*)theStartDate andWithdrawPriority:(double)theWithdrawPriority
{
	self = [super init];
	if(self)
	{
		self.balanceStartDate = theStartDate;
		//[DateHelper beginningOfDay:[SharedAppValues singleton].simStartDate];
		startingBalance = theStartBalance;
		
		[self resetCurrentBalance];
		
		self.withdrawPriority = theWithdrawPriority;
		
		// By default, there is no deferral of withdrawals.
		self.deferWithdrawalsUntil = nil;
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

-(BOOL)withdrawalsEnabledAsOfDate:(NSDate*)theDate
{
	assert(theDate != nil);
	if(self.deferWithdrawalsUntil != nil)
	{
		if([DateHelper dateIsEqualOrLater:theDate 
			otherDate:[DateHelper beginningOfDay:self.deferWithdrawalsUntil]])
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	else
	{
		return TRUE;
	}
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
	return [[[BalanceAdjustment alloc] initWithAmount:theAmount] autorelease];
}

- (WorkingBalanceAdjustment*) decrementAvailableBalance:(double)amount asOfDate:(NSDate*)newDate
{
	BalanceAdjustment *interestAmount = [self advanceCurrentBalanceToDate:newDate];
	
	assert(amount >= 0.0);	

	BalanceAdjustment *decrementAmount;
	if([self withdrawalsEnabledAsOfDate:newDate])
	{
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
	}
	else
	{
			decrementAmount = [self createBalanceAdjustmentForWithdrawAmount:0.0];		
	}
	
	
	return [[[WorkingBalanceAdjustment alloc] initWithBalanceAdjustment:decrementAmount 
		andInterestAdjustment:interestAmount] autorelease];

}

- (double)zeroOutBalanceAsOfDate:(NSDate*)newDate
{
	// First advance the date, ensuring that any interest/adjustement leading up 
	// to newDate are included in the balance.
	[self advanceCurrentBalanceToDate:newDate];
	
	if([self withdrawalsEnabledAsOfDate:newDate])
	{
		double remainingBalance = [self currentBalance];
	
		[self decrementAvailableBalance:remainingBalance asOfDate:newDate];
	
		currentBalance = 0.0;
	
		return remainingBalance;
	}
	else
	{
		return 0.0;
	}
	
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
