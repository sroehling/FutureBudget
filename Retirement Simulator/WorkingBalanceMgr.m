//
//  WorkingBalanceList.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingBalanceMgr.h"
#import "SharedAppValues.h"
#import "WorkingBalance.h"
#import "CashWorkingBalance.h"
#import "NumberHelper.h"
#import "DateHelper.h"
#import "LocalizationHelper.h"
#import "FixedValue.h"
#import "Cash.h"
#import "SavingsWorkingBalance.h"
#import "BalanceAdjustment.h"

@implementation WorkingBalanceMgr

@synthesize fundingSources;
@synthesize cashWorkingBalance;
@synthesize deficitBalance;

- (id) initWithCashBalance:(CashWorkingBalance*)cashBal 
	andDeficitBalance:(SavingsWorkingBalance*)deficitBal
{
	self = [super init];
	if(self)
	{
		self.fundingSources = [[[NSMutableArray alloc] init] autorelease];
		[self addFundingSource:cashBal];
		
		assert(cashBal != nil);
		self.cashWorkingBalance = cashBal;
		
		assert(deficitBal!=nil);
		self.deficitBalance = deficitBal;

	}
	return self;

}

- (id)initWithStartDate:(NSDate*)startDate
{
		CashWorkingBalance *cashBal = [[[CashWorkingBalance alloc] init] autorelease];
		
		SavingsWorkingBalance *deficitBal = [[[SavingsWorkingBalance alloc] 
			initWithStartingBalance:0.0 
			andInterestRate:[SharedAppValues singleton].deficitInterestRate 
				andWorkingBalanceName:LOCALIZED_STR(@"DEFICIT_LABEL") 
				andStartDate:startDate andTaxWithdrawals:FALSE 
				andTaxInterest:TRUE] autorelease];
	return [self initWithCashBalance:cashBal andDeficitBalance:deficitBal];
}

- (id) init
{
	assert(0); // need to call with start date
}

- (void)addFundingSource:(WorkingBalance *)theBalance
{
	assert(theBalance!= nil);
	[self.fundingSources addObject:theBalance];
}

- (void)carryBalancesForward:(NSDate*)newDate
{
	assert(newDate != nil);
	for(WorkingBalance *workingBal in self.fundingSources)
	{
		assert(workingBal!=nil);
		[workingBal carryBalanceForward:newDate];
	}
	[self.deficitBalance carryBalanceForward:newDate];
	
	NSString *currentCashCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.cashWorkingBalance.currentBalance]];
	NSLog(@"Total Cash balance: %@",currentCashCurrency);

}



- (BalanceAdjustment*) decrementBalanceFromFundingList:(double)expenseAmount  asOfDate:(NSDate*)newDate
{
	double remainingBalanceToDecrement = expenseAmount;
	BalanceAdjustment *totalDecremented = [[[BalanceAdjustment alloc] initWithTaxFreeAmount:0.0 andTaxableAmount:0.0] autorelease];
	for(WorkingBalance *workingBal in self.fundingSources)
	{
		BalanceAdjustment * amountDecremented = 
			[workingBal decrementAvailableBalance:remainingBalanceToDecrement 
			asOfDate:newDate];
		assert([amountDecremented totalAmount] <= remainingBalanceToDecrement);
		[totalDecremented addAdjustment:amountDecremented];
		remainingBalanceToDecrement -= [amountDecremented totalAmount];
		if(remainingBalanceToDecrement <= 0.0)
		{
			return totalDecremented;
		}
	}
	assert([totalDecremented totalAmount] <= expenseAmount);
	if([totalDecremented totalAmount] < expenseAmount)
	{
		double deficitAmount = expenseAmount - [totalDecremented totalAmount];
		[self.deficitBalance incrementBalance:deficitAmount asOfDate:newDate];
	}
	return totalDecremented;

}

- (void) incrementCashBalance:(double)incomeAmount  asOfDate:(NSDate*)newDate
{
	// Reduce the deficit first
	assert(incomeAmount >= 0.0);
	BalanceAdjustment *deficitReduction = [self.deficitBalance 
		decrementAvailableBalance:incomeAmount asOfDate:newDate];
	assert([deficitReduction totalAmount] <= incomeAmount);
	
	// Put the remainder into the cash balance
	double incomeAvailableForCashIncrement = incomeAmount - [deficitReduction totalAmount];
	[self.cashWorkingBalance incrementBalance:incomeAvailableForCashIncrement asOfDate:newDate];
}

- (double) decrementAvailableCashBalance:(double)expenseAmount asOfDate:(NSDate*)newDate
{
	[self.deficitBalance advanceCurrentBalanceToDate:newDate];
	[self.cashWorkingBalance advanceCurrentBalanceToDate:newDate];
	if(self.deficitBalance.currentBalance > 0.0)
	{
		assert(self.cashWorkingBalance.currentBalance == 0.0);
		return 0.0;
	}
	else
	{
		BalanceAdjustment *decrementAmount = [self.cashWorkingBalance 
			decrementAvailableBalance:expenseAmount asOfDate:newDate];
		return [decrementAmount totalAmount];
	}
}

- (void) resetCurrentBalances
{
	for(WorkingBalance *workingBal in self.fundingSources)
	{
		assert(workingBal!=nil);
		[workingBal resetCurrentBalance];
	}
	[self.deficitBalance resetCurrentBalance];

}

- (void)logCurrentBalances
{
	for(WorkingBalance *workingBal in self.fundingSources)
	{
		[workingBal logBalance];
	}
	[self.deficitBalance logBalance];
}

- (void) dealloc
{
	[super dealloc];
	[fundingSources release];
	[cashWorkingBalance release];
	[deficitBalance release];
}

@end
