//
//  LoanSimInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanSimInfo.h"
#import "LoanInput.h"
#import "SimInputHelper.h"
#import "VariableRate.h"
#import "DateHelper.h"
#import "VariableRateCalculator.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "InterestBearingWorkingBalance.h"
#import "EventRepeater.h"
#import "SharedAppValues.h"
#import "SimParams.h"
#import "NeverEndDate.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioSimDate.h"
#import "MultiScenarioSimEndDate.h"
#import "DigestEntryProcessingParams.h"
#import "InputValDigestSummations.h"
#import "LoanSimConfigParams.h"
#import "PeriodicInterestBearingWorkingBalance.h"
#import "MultiScenarioInputValue.h"
#import "LoanPmtHelper.h"

@implementation LoanSimInfo

@synthesize loan;
@synthesize loanBalance;
@synthesize extraPmtGrowthCalc;
@synthesize simParams;
@synthesize currentMonthlyPayment;

-(void)dealloc
{
	[loan release];
	[loanBalance release];
	[extraPmtGrowthCalc release];
	[simParams release];
	[super dealloc];
}

-(NSDate*)earlyPayoffDate
{
	assert(self.loan.earlyPayoffDate != nil);
	return [SimInputHelper 
			multiScenEndDate:self.loan.earlyPayoffDate.simDate 
			withStartDate:self.loan.origDate.simDate 
			andScenario:self.simParams.simScenario];
}

-(bool)earlyPayoffAfterOrigination
{
	if([DateHelper dateIsEqualOrLater:[self earlyPayoffDate] otherDate:[self loanOrigDate]])
	{
		return true;
	}
	else
	{
		return false;
	}
}

- (bool)earlyPayoffAfterSimStart
{
	if([DateHelper dateIsEqualOrLater:[self earlyPayoffDate] otherDate:self.simParams.simStartDate])
	{
		return true;
	}
	else
	{
		return false;
	}

}


-(bool)loanOriginatesAfterSimStart;
{
	NSDate *loanOrigDate = [self loanOrigDate];
		
	if([DateHelper dateIsEqualOrLater:loanOrigDate otherDate:self.simParams.simStartDate])
	{
		return true;
	}
	else
	{
		return false;
	}

}



-(NSDate*)loanOrigDate
{
	assert(self.loan.origDate != nil);
	return [SimInputHelper multiScenFixedDate:self.loan.origDate.simDate
			andScenario:simParams.simScenario];
}

- (double)loanOrigAmount
{
	// Calculate the monthly payment, based upon the loan origination amount and interest rate.
	assert(self.loan.loanCost != nil);
	double origAmount = [SimInputHelper multiScenValueAsOfDate:self.loan.loanCost.amount 
			andDate:[self loanOrigDate] andScenario:simParams.simScenario];
			
	if([self loanOriginatesAfterSimStart])
	{
		// If the loan originates in the future w.r.t the simulation start date, then
		// the amount borrowed (i.e., "loan cost") is adjusted by the loan cost growth rate.
		double origAmountMultiplier = [SimInputHelper multiScenVariableRateMultiplier:self.loan.loanCostGrowthRate.growthRate sinceStartDate:self.simParams.simStartDate 
			asOfDate:[self loanOrigDate] andScenario:simParams.simScenario];
		origAmount = origAmount * origAmountMultiplier;
	}
			
	assert(origAmount >= 0.0);
	return origAmount;
}

-(NSDate*)deferredPaymentDate
{
	NSDate *deferredPaymentDate = [SimInputHelper
		multiScenEndDate:self.loan.deferredPaymentDate.simDate
		withStartDate:self.loan.origDate.simDate andScenario:simParams.simScenario];
	
	return deferredPaymentDate;
}

-(BOOL)deferredPaymentDateEnabled
{
	BOOL deferredPmtEnabled = [SimInputHelper multiScenBoolVal:loan.deferredPaymentEnabled
				andScenario:simParams.simScenario];
	return deferredPmtEnabled;
}

-(BOOL)deferredPaymentPayInterestWhileInDeferrment
{
	return [SimInputHelper multiScenBoolVal:loan.deferredPaymentPayInterest
				andScenario:simParams.simScenario];
}

-(BOOL)deferredPaymentInterestSubsidized
{
	return [SimInputHelper multiScenBoolVal:loan.deferredPaymentSubsizedInterest
				andScenario:simParams.simScenario];
}


-(BOOL)beforeDeferredPaymentDate:(NSDate*)pmtDate
{
	NSDate *deferredPaymentDate = [self deferredPaymentDate];
	
	if([DateHelper dateIsLater:deferredPaymentDate otherDate:pmtDate])
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}

}


-(double)loanTermMonths
{
	assert(loan.loanDuration != nil);
	double termMonths = [SimInputHelper multiScenFixedVal:loan.loanDuration
		andScenario:simParams.simScenario];
	assert(termMonths > 0.0);
	return termMonths;
}

- (double)extraPmtAmountAsOfDate:(NSDate*)pmtDate
{	
	if([SimInputHelper multiScenBoolVal:loan.extraPmtEnabled
				andScenario:simParams.simScenario])
	{
		double extraPmtAsOfDate = 
			[SimInputHelper multiScenValueAsOfDate:self.loan.extraPmtAmt.amount andDate:pmtDate
					andScenario:simParams.simScenario];
		
		double extraPmtGrowthSinceSimStart = [self.extraPmtGrowthCalc valueMultiplierForDate:pmtDate];
		
		extraPmtAsOfDate = extraPmtAsOfDate * extraPmtGrowthSinceSimStart;
		
		assert(extraPmtAsOfDate >= 0.0);
			
		return extraPmtAsOfDate;
	}
	else
	{
		return 0.0;
	}

}

-(double)totalMonthlyPmtAsOfDate:(NSDate*)pmtDate
{
	double extraPayment = [self extraPmtAmountAsOfDate:pmtDate];
	double totalPayment = self.currentMonthlyPayment + extraPayment;
	return totalPayment;
}


- (EventRepeater*)createLoanEventRepeater
{
	// An event repeater is set up for monthly payments. It repeats indefinitely,
	// because the principal reaching 0 is used to stop event repeating, not
	// a fixed number of repetitions.
	NSDate *resolvedStartDate = [self loanOrigDate];
	NSDate *resolvedEndDate = self.simParams.simEndDate;
	
	NSLog(@"Loan origination date: date = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:resolvedStartDate]);

	NSDateComponents *monthlyLoanPmtOffset = [[[NSDateComponents alloc] init] autorelease];
	[monthlyLoanPmtOffset setMonth:1];
	
    EventRepeater *pmtRepeater = [[[EventRepeater alloc] 
                     initWithRepeatOffset:monthlyLoanPmtOffset andRepeatOnce:FALSE 
					andStartDate:resolvedStartDate andEndDate:resolvedEndDate] autorelease];
	return pmtRepeater;

}


-(double)downPaymentPercent
{
	double downPmtPercent = [SimInputHelper 
		multiScenValueAsOfDate:self.loan.multiScenarioDownPmtPercent 
		andDate:[self loanOrigDate] andScenario:simParams.simScenario];
	assert(downPmtPercent >= 0.0);
	assert(downPmtPercent <= 100.0);
	return downPmtPercent/100.0;
}

-(double)downPaymentAmount
{
	if([SimInputHelper multiScenBoolVal:self.loan.downPmtEnabled 
			andScenario:simParams.simScenario])
	{
		double downPmtPercent = [self downPaymentPercent];
		double totalLoanOrig = [self loanOrigAmount];
		double downPmtAmount = downPmtPercent * totalLoanOrig;
		return downPmtAmount;
	}
	else
	{
		return 0.0;
	}
}


- (double)startingBalanceAfterDownPayment
{
	double loanOrig = [self loanOrigAmount];
	double downPmtAmount = [self downPaymentAmount];
	double startingBal = loanOrig - downPmtAmount;
	assert(startingBal >= 0.0);
	return startingBal;
}

-(double)monthlyPaymentForPmtCalcDate:(NSDate*)pmtCalcDate andStartingBal:(double)startingBal
{
	assert(startingBal >= 0.0);

	double annualInterestRateAsOfLoanPmtCalcDate =
		[SimInputHelper multiScenValueAsOfDate:self.loan.interestRate.growthRate 
			andDate:pmtCalcDate andScenario:simParams.simScenario];
	double monthlyInterestRateAsOfPmtCalcDate =
		[LoanPmtHelper monthlyPeriodicLoanInterestRate:annualInterestRateAsOfLoanPmtCalcDate];
	
	double payment = [VariableRate periodicPaymentForPrincipal:startingBal
			andPeriodRate:monthlyInterestRateAsOfPmtCalcDate andNumPeriods:[self loanTermMonths]];
	assert(payment >= 0.0);
	
	return payment;
}


- (double)monthlyPaymentForPaymentsStartingAtLoanOrig
{

	double startingBal = [self startingBalanceAfterDownPayment];
	NSDate *pmtCalcDate = [self loanOrigDate];
	
	double monthlyPmt = [self monthlyPaymentForPmtCalcDate:pmtCalcDate andStartingBal:startingBal];
	
	return monthlyPmt;
}




- (EventRepeater*)createLoanPmtRepeater
{
	EventRepeater *pmtRepeater = [self createLoanEventRepeater];
	assert(pmtRepeater != nil);
	
	// The first payment always happens one month after origination.
	[pmtRepeater nextDate];

	return pmtRepeater;	
}

-(LoanSimConfigParams*)configParamsForLoanOrigination
{

	EventRepeater *pmtRepeater = [self createLoanPmtRepeater];
	double startingBalAtLoanOrig = [self startingBalanceAfterDownPayment];
	NSDate *loanOrigDate = [self loanOrigDate];

	// Start with a default configuration
	LoanSimConfigParams *configParams = [[[LoanSimConfigParams alloc] init] autorelease];
	configParams.monthlyPmt = [self monthlyPaymentForPaymentsStartingAtLoanOrig];
	configParams.interestStartDate = [self loanOrigDate];
	configParams.startingBal = [self startingBalanceAfterDownPayment];
	
	
	if([self loanOriginatesAfterSimStart])
	{
			// The loan will occur/originate in the future (w.r.t. to simulation start date):
			//
			// If the origination date is after the simulation start date, then the "starting balance"
			// on the loan should be ignored. This is because the loan will start after the simulation
			// start date, with a balance that is equal to the total amount borrowed.
			//
			// In this case, we can return the configuration parameters with their defaults.
			return configParams;
	}

	// If we drop through to here, the loan is existing as of the simulation start date:
	//
	// In this case the simulation start date is after the origination date. So,
	// we need to use the "starting balance" for the loan, to account for the all
	// the prior payments already made on the loan (plus any extra payments, etc.)
	// If a starting balance hasn't been provided by the user, then "simulate" the
	// starting balance by computing payments and interest before the simulation
	// start date.



	// If early payoff is enabled and is before the sim start, then
	// the starting balance is always 0.0, since the loan was paid
	// off before the simulation start.
	if([self earlyPayoffAfterOrigination] &&
			(![self earlyPayoffAfterSimStart]))
	{
		configParams.startingBal = 0.0;
		return configParams;
	}

	
	// TBD - What do we do about extra payments?
	
	DateSensitiveValue *loanInterestRate = (DateSensitiveValue*)[
			self.loan.interestRate.growthRate
			getValueForScenarioOrDefault:simParams.simScenario];
	
	PeriodicInterestBearingWorkingBalance *loanBalanceBeforeSimStart =
		[[[PeriodicInterestBearingWorkingBalance alloc]
			initWithStartingBalance:startingBalAtLoanOrig andInterestRate:loanInterestRate
			andWorkingBalanceName:self.loan.name
			andStartDate:loanOrigDate ] autorelease];
	
	configParams.startingBal = [loanBalanceBeforeSimStart currentBalanceForDate:loanOrigDate];
	
	
	// Loan exists as of the start date. Interest starts on the last
	// payment date before the sim start date.
	
	NSDate *pmtDate = [pmtRepeater nextDate];
	assert(pmtDate != nil);
	
	BOOL hasDeferredPayments = [self deferredPaymentDateEnabled];
	BOOL payInterestUnderDeferrment = [self deferredPaymentPayInterestWhileInDeferrment];
	BOOL firstDeferredPaymentMade = FALSE;
	
// TODO - Need to test for boundary case where first pmt is on the simulation start date.
	while([DateHelper dateIsLater:self.simParams.simStartDate otherDate:pmtDate])
	{
		[loanBalanceBeforeSimStart carryBalanceForward:pmtDate];
		double balanceBeforeAddingPeriodInterest = [loanBalanceBeforeSimStart currentBalanceForDate:pmtDate];
		[loanBalanceBeforeSimStart advanceCurrentBalanceToNextPeriodOnDate:pmtDate];

		if(hasDeferredPayments)
		{
			if([self beforeDeferredPaymentDate:pmtDate])
			{
				if(payInterestUnderDeferrment)
				{
				
					// Note, in this case, there is no need to handle subsidized interest
					// because at the beginning of simulation, the cash balances are
					// expected to have any subsidized interest payments (or lack-thereof)
					// included ("baked into") the starting balances.
				
					double currBalance = [loanBalanceBeforeSimStart currentBalanceForDate:pmtDate];
					assert(currBalance >= startingBalAtLoanOrig);
					double accruedInterest = currBalance - startingBalAtLoanOrig;
					
					[loanBalanceBeforeSimStart decrementAvailableBalanceForNonExpense:accruedInterest
						asOfDate:pmtDate];
				}
				// Else, let the interest accrue while in deferrment
			}
			else
			{
				if(!firstDeferredPaymentMade)
				{
					// Set the regular payment amount based upon the balance as of the first deferred
					// payment date.
					configParams.monthlyPmt = [self monthlyPaymentForPmtCalcDate:pmtDate
						andStartingBal:balanceBeforeAddingPeriodInterest];

					firstDeferredPaymentMade = TRUE;
				}
				[loanBalanceBeforeSimStart decrementAvailableBalanceForNonExpense:configParams.monthlyPmt asOfDate:pmtDate];
			}
		}
		else
		{
			[loanBalanceBeforeSimStart decrementAvailableBalanceForNonExpense:configParams.monthlyPmt asOfDate:pmtDate];
		}
		
		// If we get to here, the payment date is still before
		// the start of simulation date. We keep on updating/advancing
		// configParams.interestStartDate until the payment date is
		// after the simulation start date. We also advance the starting
		// balance configParams.startingBal to correspond with the
		// interest start date.
		configParams.interestStartDate = pmtDate;
		configParams.startingBal = [loanBalanceBeforeSimStart currentBalanceForDate:pmtDate];

		pmtDate = [pmtRepeater nextDate];
		assert(pmtDate != nil);
		
	}

	if(self.loan.startingBalance != nil)
	{
		// If an explicit 
		configParams.startingBal = [self.loan.startingBalance doubleValue];
	}


	return configParams;
}


-(id)initWithLoan:(LoanInput*)theLoan andSimParams:(SimParams*)theParams
{
	self = [super init];
	if(self)
	{
		assert(theLoan != nil);
		self.loan = theLoan;
		
		assert(theParams != nil);
		self.simParams = theParams;


		LoanSimConfigParams *loanConfig = [self configParamsForLoanOrigination];
		assert(loanConfig.monthlyPmt >= 0.0);
		assert(loanConfig.interestStartDate != nil);
		assert(loanConfig.startingBal >= 0.0);
		
		// The currentMonthlyPayment is referenced for regular loan payments. This property is
		// referenced for digest processing of regular loan payments. In the event of
		// deferred loan payments, it may be updated to reflect the loan payment as of the
		// first deferred loan payment, rather than the loan payment as of the origination.
		self.currentMonthlyPayment = loanConfig.monthlyPmt;

		// Setup the working balance for the loan principal.
			
		DateSensitiveValue *loanInterestRate = (DateSensitiveValue*)[
			self.loan.interestRate.growthRate
			getValueForScenarioOrDefault:simParams.simScenario];
	
		self.loanBalance = [[[PeriodicInterestBearingWorkingBalance alloc]
			initWithStartingBalance:loanConfig.startingBal andInterestRate:loanInterestRate
			andWorkingBalanceName:self.loan.name
			andStartDate:loanConfig.interestStartDate ] autorelease];
			
		[simParams.digestSums addDigestSum:self.loanBalance.accruedInterest];
			
		self.extraPmtGrowthCalc	= [DateSensitiveValueVariableRateCalculatorCreator
			createVariableRateCalc:loan.extraPmtGrowthRate.growthRate
			andStartDate:self.simParams.simStartDate andScenario:simParams.simScenario
			andUseLoanAnnualRates:false];
			
		
	}
	return self;
}



-(id)init
{
	assert(0); // must unit with Loan
	return nil;
}


@end
