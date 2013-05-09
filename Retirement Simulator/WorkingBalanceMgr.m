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
#import "WorkingBalanceCltn.h"

static const CGFloat kBalanceDecrementComparisonTolerance = 0.001;


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

- (id)initWithStartDate:(NSDate*)startDate andCashBal:(double)startingCashBal 
		andDeficitInterestRate:(FixedValue*)deficitRate andDeficitBalance:(double)startingDeficitBal
{

		assert(startingCashBal >= 0.0);
		

		CashWorkingBalance *cashBal = [[[CashWorkingBalance alloc] 
				initWithStartingBalance:startingCashBal 
				andStartDate:startDate] autorelease];
		
		assert(startingDeficitBal >= 0.0);
		InterestBearingWorkingBalance *deficitBal = [[[InterestBearingWorkingBalance alloc] 
			initWithStartingBalance:startingDeficitBal
			andInterestRate:deficitRate 
				andWorkingBalanceName:LOCALIZED_STR(@"DEFICIT_LABEL") 
				andStartDate:startDate andWithdrawPriority:WORKING_BALANCE_WITHDRAW_PRIORITY_MAX] autorelease];
				
		return [self initWithCashBalance:cashBal andDeficitBalance:deficitBal andStartDate:startDate];
}

- (id) init
{
	assert(0); // need to call with start date
}



- (void)advanceBalancesToDate:(NSDate*)newDate
{
	// Note - Even though cashWorkingBalance is in self.fundingSources,
	// we advance cashWorkingBalance up front, ensuring it is not tallied with
	// the other funding sources.
	[self.deficitBalance advanceCurrentBalanceToDate:newDate];
	[self.cashWorkingBalance advanceCurrentBalanceToDate:newDate];
	
	[self.fundingSources advanceBalancesToDate:newDate];
	
	[self.loanBalances advanceBalancesToDate:newDate];
	[self.assetValues advanceBalancesToDate:newDate];
		
	[self.accruedEstimatedTaxes advanceCurrentBalanceToDate:newDate];

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
				stringFromNumber:[NSNumber numberWithDouble:[self.cashWorkingBalance currentBalanceForDate:newDate]]];
	NSLog(@"Total Cash balance: %@",currentCashCurrency);

}



- (double) decrementBalanceFromFundingList:(double)expenseAmount  asOfDate:(NSDate*)newDate
	forExpense:(ExpenseInput*)expense
{
	double remainingBalanceToDecrement = expenseAmount;
	double totalDecremented = 0.0;
		
	[self.fundingSources sortByWithdrawalOrder];	
		
	for(id<WorkingBalance> workingBal in self.fundingSources.workingBalList)
	{
		double amountDecremented;
		if(expense != nil)
		{
			amountDecremented = [workingBal decrementAvailableBalanceForExpense:expense 
				andAmount:remainingBalanceToDecrement 
				asOfDate:newDate];
		}
		else
		{
			amountDecremented = [workingBal decrementAvailableBalanceForNonExpense:remainingBalanceToDecrement 
				asOfDate:newDate];
		}
		assert(amountDecremented <= remainingBalanceToDecrement);
		totalDecremented += amountDecremented;
		remainingBalanceToDecrement -= amountDecremented;
		if(remainingBalanceToDecrement <= 0.0)
		{
			assert(totalDecremented <= (expenseAmount + kBalanceDecrementComparisonTolerance));
			return totalDecremented;
		}
	}
	assert(totalDecremented <= expenseAmount);
	if(totalDecremented < expenseAmount)
	{
		double deficitAmount = expenseAmount - totalDecremented;
		[self.deficitBalance incrementBalance:deficitAmount asOfDate:newDate];
	}
	assert(totalDecremented <= expenseAmount);
	return totalDecremented;

}

- (double) decrementBalanceFromFundingList:(double)expenseAmount  asOfDate:(NSDate*)newDate
{
	return [self decrementBalanceFromFundingList:expenseAmount asOfDate:newDate forExpense:nil];
}

- (double)totalCurrentNetBalance:(NSDate*)currentDate
{
	double totalBal = 
		[self.fundingSources totalBalances:currentDate] + 
		[self.assetValues totalBalances:currentDate] - 
		[self.loanBalances totalBalances:currentDate] - 
		[self.deficitBalance currentBalanceForDate:currentDate];
	return totalBal;
}

- (void) incrementCashBalance:(double)incomeAmount  asOfDate:(NSDate*)newDate
{
	// Reduce the deficit first
	assert(incomeAmount >= 0.0);
	double deficitReduction = [self.deficitBalance 
		decrementAvailableBalanceForNonExpense:incomeAmount asOfDate:newDate];

	assert(deficitReduction <= incomeAmount);
	
	// Put the remainder into the cash balance
	double incomeAvailableForCashIncrement = incomeAmount - deficitReduction;
	
	[self.cashWorkingBalance incrementBalance:incomeAvailableForCashIncrement asOfDate:newDate];
}

- (double) decrementAvailableCashBalance:(double)expenseAmount asOfDate:(NSDate*)newDate
{
	[self.deficitBalance advanceCurrentBalanceToDate:newDate];
	[self.cashWorkingBalance advanceCurrentBalanceToDate:newDate];
	
	if([self.deficitBalance currentBalanceForDate:newDate] > 0.0)
	{
		assert([self.cashWorkingBalance currentBalanceForDate:newDate] <= 0.0);
		return 0.0;
	}
	else
	{
		double decrementAmount = [self.cashWorkingBalance 
			decrementAvailableBalanceForNonExpense:expenseAmount asOfDate:newDate];
		return decrementAmount;
	}
}

- (void)incrementAccruedEstimatedTaxes:(double)taxAmount asOfDate:(NSDate*)theDate
{
	[self.accruedEstimatedTaxes incrementBalance:taxAmount asOfDate:theDate];
}

- (void)setAsideAccruedEstimatedTaxesForNextTaxPaymentAsOfDate:(NSDate*)theDate;
{
	[self.accruedEstimatedTaxes advanceCurrentBalanceToDate:theDate];
	double accruedBalance = [self.accruedEstimatedTaxes currentBalanceForDate:theDate];
	[self.accruedEstimatedTaxes decrementAvailableBalanceForNonExpense:accruedBalance asOfDate:theDate];
	[self.nextEstimatedTaxPayment incrementBalance:accruedBalance asOfDate:theDate];
}

- (double)decrementNextEstimatedTaxPaymentAsOfDate:(NSDate*)theDate
{
	[self.nextEstimatedTaxPayment advanceCurrentBalanceToDate:theDate];
	double paymentAmount = [self.nextEstimatedTaxPayment currentBalanceForDate:theDate];
	assert(paymentAmount >= 0.0);
	[self.nextEstimatedTaxPayment decrementAvailableBalanceForNonExpense:paymentAmount asOfDate:theDate];
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


- (void) dealloc
{
	
	[fundingSources release];
	[loanBalances release];
	[assetValues release];

	[cashWorkingBalance release];
	[deficitBalance release];

	[accruedEstimatedTaxes release];
	[nextEstimatedTaxPayment release];
	[super dealloc];
}

@end
