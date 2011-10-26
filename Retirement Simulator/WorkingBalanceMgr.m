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
#import "InterestBearingWorkingBalance.h"
#import "BalanceAdjustment.h"
#import "WorkingBalanceAdjustment.h"
#import "WorkingBalanceCltn.h"

@implementation WorkingBalanceMgr

@synthesize fundingSources;
@synthesize loanBalances;
@synthesize cashWorkingBalance;
@synthesize deficitBalance;
@synthesize accruedEstimatedTaxes;
@synthesize nextEstimatedTaxPayment;
@synthesize assetValues;

- (id) initWithCashBalance:(CashWorkingBalance*)cashBal 
	andDeficitBalance:(InterestBearingWorkingBalance*)deficitBal
	andStartDate:(NSDate*)startDate
{
	self = [super init];
	if(self)
	{
		self.fundingSources = [[[WorkingBalanceCltn alloc] init] autorelease];
		[self.fundingSources addBalance:cashBal];
		
		self.loanBalances = [[[WorkingBalanceCltn alloc] init] autorelease];
		self.assetValues = [[[WorkingBalanceCltn alloc] init] autorelease];
		
		assert(cashBal != nil);
		self.cashWorkingBalance = cashBal;
		
		self.accruedEstimatedTaxes = [[[CashWorkingBalance alloc] initWithStartingBalance:0.0 
			andStartDate:startDate] autorelease];
		self.nextEstimatedTaxPayment = [[[CashWorkingBalance alloc] initWithStartingBalance:0.0 
			andStartDate:startDate] autorelease];
		
		assert(deficitBal!=nil);
		self.deficitBalance = deficitBal;

	}
	return self;

}

- (id)initWithStartDate:(NSDate*)startDate
{
		CashWorkingBalance *cashBal = [[[CashWorkingBalance alloc] init] autorelease];
		
		InterestBearingWorkingBalance *deficitBal = [[[InterestBearingWorkingBalance alloc] 
			initWithStartingBalance:0.0 
			andInterestRate:[SharedAppValues singleton].deficitInterestRate 
				andWorkingBalanceName:LOCALIZED_STR(@"DEFICIT_LABEL") 
				andStartDate:startDate andWithdrawPriority:WORKING_BALANCE_WITHDRAW_PRIORITY_MAX] autorelease];
				
		return [self initWithCashBalance:cashBal andDeficitBalance:deficitBal andStartDate:startDate];
}

- (id) init
{
	assert(0); // need to call with start date
}



- (BalanceAdjustment*)advanceBalancesToDate:(NSDate*)newDate
{
	// Note - Even though cashWorkingBalance is in self.fundingSources,
	// we advance cashWorkingBalance up front, ensuring it is not tallied with
	// the other funding sources.
	[self.deficitBalance advanceCurrentBalanceToDate:newDate];
	[self.cashWorkingBalance advanceCurrentBalanceToDate:newDate];
	
	BalanceAdjustment *fundingSrcInterest = [self.fundingSources advanceBalancesToDate:newDate];
	
// TODO - Need to do something with the loan interest.
	BalanceAdjustment *loanInterest = [self.loanBalances advanceBalancesToDate:newDate];
	[self.assetValues advanceBalancesToDate:newDate];
		
	[self.accruedEstimatedTaxes advanceCurrentBalanceToDate:newDate];

	return fundingSrcInterest;
}


- (void)carryBalancesForward:(NSDate*)newDate
{
	assert(newDate != nil);
	
	[self.fundingSources carryBalancesForward:newDate];
	[self.loanBalances carryBalancesForward:newDate];
	[self.assetValues carryBalancesForward:newDate];

	
	[self.deficitBalance carryBalanceForward:newDate];
	[self.accruedEstimatedTaxes carryBalanceForward:newDate];
	[self.nextEstimatedTaxPayment carryBalanceForward:newDate];
	
	NSString *currentCashCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.cashWorkingBalance.currentBalance]];
	NSLog(@"Total Cash balance: %@",currentCashCurrency);

}



- (WorkingBalanceAdjustment*) decrementBalanceFromFundingList:(double)expenseAmount  asOfDate:(NSDate*)newDate
{
	double remainingBalanceToDecrement = expenseAmount;
	WorkingBalanceAdjustment *totalDecremented = 
		[[[WorkingBalanceAdjustment alloc] initWithZeroAmounts] autorelease];
		
	[self.fundingSources sortByWithdrawalOrder];	
		
	for(WorkingBalance *workingBal in self.fundingSources.workingBalList)
	{
		WorkingBalanceAdjustment * amountDecremented = 
			[workingBal decrementAvailableBalance:remainingBalanceToDecrement 
			asOfDate:newDate];
		assert([amountDecremented.balanceAdjustment totalAmount] <= remainingBalanceToDecrement);
		[totalDecremented addAdjustment:amountDecremented];
		remainingBalanceToDecrement -= [amountDecremented.balanceAdjustment totalAmount];
		if(remainingBalanceToDecrement <= 0.0)
		{
			assert([totalDecremented.balanceAdjustment totalAmount] <= expenseAmount);
			return totalDecremented;
		}
	}
	assert([totalDecremented.balanceAdjustment totalAmount] <= expenseAmount);
	if([totalDecremented.balanceAdjustment totalAmount] < expenseAmount)
	{
		double deficitAmount = expenseAmount - [totalDecremented.balanceAdjustment totalAmount];
		[self.deficitBalance incrementBalance:deficitAmount asOfDate:newDate];
	}
	assert([totalDecremented.balanceAdjustment totalAmount] <= expenseAmount);
	return totalDecremented;

}

- (double)totalCurrentNetBalance
{
	double totalBal = [self.fundingSources totalBalances] + [self.assetValues totalBalances] - [self.loanBalances totalBalances] - [self.deficitBalance currentBalance];
	return totalBal;
}

- (void) incrementCashBalance:(double)incomeAmount  asOfDate:(NSDate*)newDate
{
	// Reduce the deficit first
	assert(incomeAmount >= 0.0);
	WorkingBalanceAdjustment *deficitReduction = [self.deficitBalance 
		decrementAvailableBalance:incomeAmount asOfDate:newDate];
	assert([deficitReduction.balanceAdjustment totalAmount] <= incomeAmount);
	
	// Put the remainder into the cash balance
	double incomeAvailableForCashIncrement = 
		incomeAmount - [deficitReduction.balanceAdjustment totalAmount];
	[self.cashWorkingBalance incrementBalance:incomeAvailableForCashIncrement asOfDate:newDate];
}

- (double) decrementAvailableCashBalance:(double)expenseAmount asOfDate:(NSDate*)newDate
{
	[self.deficitBalance advanceCurrentBalanceToDate:newDate];
	[self.cashWorkingBalance advanceCurrentBalanceToDate:newDate];
	
	if(self.deficitBalance.currentBalance > 0.0)
	{
		assert(self.cashWorkingBalance.currentBalance <= 0.0);
		return 0.0;
	}
	else
	{
		WorkingBalanceAdjustment *decrementAmount = [self.cashWorkingBalance 
			decrementAvailableBalance:expenseAmount asOfDate:newDate];
		return [decrementAmount.balanceAdjustment totalAmount];
	}
}

- (void)incrementAccruedEstimatedTaxes:(double)taxAmount asOfDate:(NSDate*)theDate
{
	[self.accruedEstimatedTaxes incrementBalance:taxAmount asOfDate:theDate];
}

- (void)setAsideAccruedEstimatedTaxesForNextTaxPaymentAsOfDate:(NSDate*)theDate;
{
	[self.accruedEstimatedTaxes advanceCurrentBalanceToDate:theDate];
	double accruedBalance = self.accruedEstimatedTaxes.currentBalance;
	[self.accruedEstimatedTaxes decrementAvailableBalance:accruedBalance asOfDate:theDate];
	[self.nextEstimatedTaxPayment incrementBalance:accruedBalance asOfDate:theDate];
}

- (double)decrementNextEstimatedTaxPaymentAsOfDate:(NSDate*)theDate
{
	[self.nextEstimatedTaxPayment advanceCurrentBalanceToDate:theDate];
	double paymentAmount = self.nextEstimatedTaxPayment.currentBalance;
	assert(paymentAmount >= 0.0);
	[self.nextEstimatedTaxPayment decrementAvailableBalance:paymentAmount asOfDate:theDate];
	return paymentAmount;
}

- (void) resetCurrentBalances
{
	[self.fundingSources resetCurrentBalances];
	[self.loanBalances resetCurrentBalances];
	[self.assetValues resetCurrentBalances];
	
	[self.deficitBalance resetCurrentBalance];
	[self.accruedEstimatedTaxes resetCurrentBalance];
	[self.nextEstimatedTaxPayment resetCurrentBalance];

}

- (void)logCurrentBalances
{

	[self.fundingSources logCurrentBalances];
	[self.loanBalances logCurrentBalances];
	[self.assetValues logCurrentBalances];
	
	[self.deficitBalance logBalance];
	[self.accruedEstimatedTaxes logBalance];
	[self.nextEstimatedTaxPayment logBalance];
}

- (void) dealloc
{
	[super dealloc];
	
	[fundingSources release];
	[loanBalances release];
	[assetValues release];

	[cashWorkingBalance release];
	[deficitBalance release];

	[accruedEstimatedTaxes release];
	[nextEstimatedTaxPayment release];
}

@end
