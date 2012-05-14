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
#import "NumberHelper.h"
#import "InputValDigestSummation.h"
#import "ExpenseInput.h"


NSString * const WORKING_BALANCE_WITHDRAWAL_PRIORITY_KEY = @"withdrawPriority";

@implementation WorkingBalance

@synthesize balanceStartDate;
@synthesize startingBalance;
@synthesize currentBalanceDate;
@synthesize withdrawPriority;
@synthesize deferWithdrawalsUntil;
@synthesize contribs;
@synthesize withdrawals;
@synthesize limitWithdrawalsToExpense;

- (id) initWithStartingBalance:(double)theStartBalance 
	andStartDate:(NSDate*)theStartDate andWithdrawPriority:(double)theWithdrawPriority
{
	self = [super init];
	if(self)
	{
		self.balanceStartDate = theStartDate;
		startingBalance = theStartBalance;
		
		[self resetCurrentBalance];
		
		self.withdrawPriority = theWithdrawPriority;
		
		// By default, there is no deferral of withdrawals.
		self.deferWithdrawalsUntil = nil;
		
		self.contribs = [[[InputValDigestSummation alloc] init] autorelease];
		self.withdrawals = [[[InputValDigestSummation alloc] init] autorelease];

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
	[balanceStartDate release];
	[currentBalanceDate release];
	[deferWithdrawalsUntil release];
	[limitWithdrawalsToExpense release];
	[contribs release];
	[withdrawals release];
	[super dealloc];
}

- (void)advanceCurrentBalanceToDate:(NSDate*)newDate
{
	assert(0); // must be overridden
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


- (void)carryBalanceForward:(NSDate*)newStartDate
{
	assert(newStartDate != nil);
	
	// There is only a need to advance the balance if the newDate is greater
	// than the balance start date.
	if(![DateHelper dateIsEqualOrLater:newStartDate otherDate:self.balanceStartDate])
	{
		return;
	}
	
	// There is also only a need to advance the current balance if the date of the
	// current balance is before the newStartDate. A currentBalanceDate in 
	// the future could occur for inputs such as loans originating in the future
	// or assets purchased in the future.
	if([DateHelper dateIsEqualOrLater:newStartDate otherDate:self.currentBalanceDate])
	{
		[self advanceCurrentBalanceToDate:newStartDate];
	}
	
	
	startingBalance = currentBalance;
	self.balanceStartDate = newStartDate;
}


- (void) incrementBalance:(double)amount asOfDate:(NSDate*)newDate
{
	[self advanceCurrentBalanceToDate:newDate];

	assert(amount >= 0.0);
	currentBalance += amount;
	
	NSInteger daysSinceStartDate = [DateHelper daysOffset:newDate 
		vsEarlierDate:self.balanceStartDate];
	[self.contribs adjustSum:amount onDay:daysSinceStartDate];
}

- (double)currentBalanceForDate:(NSDate*)balanceDate
{
	if([DateHelper dateIsEqualOrLater:balanceDate otherDate:self.balanceStartDate])
	{
		return currentBalance;
	}
	else
	{
		return 0.0;
	}
}


- (double) decrementAvailableBalanceImpl:(double)amount asOfDate:(NSDate*)newDate
{
	[self advanceCurrentBalanceToDate:newDate];
	
	assert(amount >= 0.0);	

	double decrementAmount;
	if([self withdrawalsEnabledAsOfDate:newDate])
	{
		if(currentBalance > 0.0)
		{
			if(amount <= currentBalance)
			{
				currentBalance -= amount;
				decrementAmount =  amount;
			}
			else
			{
				double availableAmount = currentBalance;
				currentBalance = 0.0;
				decrementAmount = availableAmount;
			}
		}
		else
		{	
			decrementAmount = 0.0;
		}
	}
	else
	{
			decrementAmount = 0.0;	
	}
	
	NSInteger daysSinceStartDate = [DateHelper daysOffset:newDate 
		vsEarlierDate:self.balanceStartDate];
	[self.withdrawals adjustSum:decrementAmount onDay:daysSinceStartDate];
	
	return decrementAmount;

}

- (double) decrementAvailableBalanceForExpense:(ExpenseInput*)expense 
	andAmount:(double)amount asOfDate:(NSDate*)newDate
{
	assert(expense != nil);
	if(self.limitWithdrawalsToExpense != nil)
	{
		if([self.limitWithdrawalsToExpense count] == 0)
		{
			return [self decrementAvailableBalanceImpl:amount asOfDate:newDate];
		}
		else if ([self.limitWithdrawalsToExpense containsObject:expense])
		{
			return [self decrementAvailableBalanceImpl:amount asOfDate:newDate];
		}
		else
		{
			return 0.0;
		}
	}
	else
	{
		return [self decrementAvailableBalanceImpl:amount 
				asOfDate:newDate];
;
	}
}

-(double)decrementAvailableBalanceForNonExpense:(double)amount 
	asOfDate:(NSDate *)newDate
{
	if((self.limitWithdrawalsToExpense != nil) &&
		([self.limitWithdrawalsToExpense count] > 0))
	{
		return 0.0;
	}
	else
	{
		return [self decrementAvailableBalanceImpl:amount asOfDate:newDate];
	}
}

- (double)zeroOutBalanceAsOfDate:(NSDate*)newDate
{
	// First advance the date, ensuring that any interest/adjustement leading up 
	// to newDate are included in the balance.
	[self advanceCurrentBalanceToDate:newDate];
	
	if([self withdrawalsEnabledAsOfDate:newDate])
	{
		double remainingBalance = currentBalance;
	
		[self decrementAvailableBalanceImpl:remainingBalance asOfDate:newDate];
	
		currentBalance = 0.0;
	
		NSInteger daysSinceStartDate = [DateHelper daysOffset:newDate 
			vsEarlierDate:self.balanceStartDate];
		[self.withdrawals adjustSum:remainingBalance onDay:daysSinceStartDate];

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
				stringFromNumber:[NSNumber numberWithDouble:currentBalance]];
		NSLog(@"Working balance: %@ %@",self.balanceName,currentBalCurrency);

}


@end
