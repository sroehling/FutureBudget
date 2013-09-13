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
#import "PeriodicInterestBearingWorkingBalance.h"
#import "MultiScenarioInputValue.h"
#import "LoanPmtHelper.h"
#import "InputValDigestSummation.h"

@implementation LoanSimInfo

@synthesize loan;
@synthesize loanBalance;
@synthesize extraPmtGrowthCalc;
@synthesize simParams;
@synthesize downPaymentSum;
@synthesize paymentSum;
@synthesize originationSum;


-(void)dealloc
{
	[loan release];
	[loanBalance release];
	[extraPmtGrowthCalc release];
	[simParams release];

	[downPaymentSum release];
	[paymentSum release];
	[originationSum release];
	
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
	if([self.simParams.dateHelper dateIsEqualOrLater:[self earlyPayoffDate] otherDate:[self loanOrigDate]])
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
	if([self.simParams.dateHelper dateIsEqualOrLater:[self earlyPayoffDate] otherDate:self.simParams.simStartDate])
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
		
	if([self.simParams.dateHelper dateIsEqualOrLater:loanOrigDate otherDate:self.simParams.simStartDate])
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
	
	if([self.simParams.dateHelper dateIsLater:deferredPaymentDate otherDate:pmtDate])
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
		
		assert(self.extraPmtGrowthCalc != nil);
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


- (EventRepeater*)createLoanEventRepeater
{
	// An event repeater is set up for monthly payments. It repeats indefinitely,
	// because the principal reaching 0 is used to stop event repeating, not
	// a fixed number of repetitions.
	NSDate *resolvedStartDate = [self loanOrigDate];
	NSDate *resolvedEndDate = self.simParams.simEndDate;
	
	NSLog(@"Loan origination date: date = %@",
		[self.simParams.dateHelper.mediumDateFormatter stringFromDate:resolvedStartDate]);
	
    EventRepeater *pmtRepeater =
		[EventRepeater monthlyEventRepeaterWithStartDate:resolvedStartDate andEndDate:resolvedEndDate];
	
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

-(PeriodicInterestBearingWorkingBalance*)configLoanBalance
{

	// Start with a default configuration	
	DateSensitiveValue *loanInterestRate = (DateSensitiveValue*)[
		self.loan.interestRate.growthRate
		getValueForScenarioOrDefault:simParams.simScenario];

	PeriodicInterestBearingWorkingBalance *loanBalanceBeforeSimStart =
		[[[PeriodicInterestBearingWorkingBalance alloc]
			initWithStartingBalance:[self startingBalanceAfterDownPayment]
			andInterestRate:loanInterestRate
			andWorkingBalanceName:self.loan.name
			andStartDate: [self loanOrigDate]
			andNumPeriods:[self loanTermMonths]] autorelease];

	if([self loanOriginatesAfterSimStart])
	{
			// The loan will occur/originate in the future (w.r.t. to simulation start date):
			//
			// If the origination date is after the simulation start date, then the "starting balance"
			// on the loan should be ignored. This is because the loan will start after the simulation
			// start date, with a balance that is equal to the total amount borrowed.
			//
			// In this case, we can return the configuration parameters with their defaults.
			
			return loanBalanceBeforeSimStart;			
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
		return [[[PeriodicInterestBearingWorkingBalance alloc] initWithExplicitStartingBalance:0.0
				andOtherBalance:loanBalanceBeforeSimStart] autorelease];			
	}
	
	// Loan exists as of the start date. Interest starts on the last
	// payment date before the sim start date.
	EventRepeater *pmtRepeater = [self createLoanPmtRepeater];	
	NSDate *pmtDate = [pmtRepeater nextDate];
	assert(pmtDate != nil);
	
	BOOL hasDeferredPayments = [self deferredPaymentDateEnabled];
	BOOL payInterestUnderDeferrment = [self deferredPaymentPayInterestWhileInDeferrment];
	BOOL firstDeferredPaymentMade = FALSE;
	
	while([self.simParams.dateHelper dateIsLater:self.simParams.simStartDate otherDate:pmtDate])
	{
		[loanBalanceBeforeSimStart carryBalanceForward:pmtDate];
				
		double extraPmtAmount = [self extraPmtAmountAsOfDate:pmtDate];

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
					[loanBalanceBeforeSimStart decrementInterestOnlyPaymentOnDate:pmtDate withExtraPmtAmount:extraPmtAmount];
				}
				else
				{
					// Let the interest accrue while in deferrment, but still process the extra payment (if any)
					[loanBalanceBeforeSimStart skippedPaymentOnDate:pmtDate withExtraPmtAmount:extraPmtAmount];
				}
			}
			else
			{
				if(!firstDeferredPaymentMade)
				{
					[loanBalanceBeforeSimStart decrementFirstNonDeferredPeriodicPaymentOnDate:pmtDate
						withExtraPmtAmount:extraPmtAmount];
					firstDeferredPaymentMade = TRUE;
				}
				else
				{
					[loanBalanceBeforeSimStart decrementPeriodicPaymentOnDate:pmtDate withExtraPmtAmount:extraPmtAmount];
				}
			}
		}
		else
		{
			[loanBalanceBeforeSimStart decrementPeriodicPaymentOnDate:pmtDate withExtraPmtAmount:extraPmtAmount];
		}

		pmtDate = [pmtRepeater nextDate];
		assert(pmtDate != nil);
		
	}

	if(self.loan.startingBalance != nil)
	{
		// If an explicit starting balance has been provided,
		// configure the loan balance with this explicit balance, but
		// with all the other loan balance parameters the same as (copied from)
		// what was simulated before the simulation start.
		return [[[PeriodicInterestBearingWorkingBalance alloc]
			initWithExplicitStartingBalance:[self.loan.startingBalance doubleValue]
			andOtherBalance:loanBalanceBeforeSimStart] autorelease];			
	}
	else
	{
		return [[[PeriodicInterestBearingWorkingBalance alloc]
			initWithOtherBalance:loanBalanceBeforeSimStart] autorelease];
	}

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
		
		self.downPaymentSum = [[[InputValDigestSummation alloc] init] autorelease];
		self.paymentSum = [[[InputValDigestSummation alloc] init] autorelease];
		self.originationSum = [[[InputValDigestSummation alloc] init] autorelease];
		
		[self.simParams.digestSums addDigestSum:self.downPaymentSum];
		[self.simParams.digestSums addDigestSum:self.paymentSum];
		[self.simParams.digestSums addDigestSum:self.originationSum];

		
		// self.extraPmtGrowthCalc is referenced inside configParamsForLoanOrigination,
		// so we need to allocate it *before* calling configParamsForLoanOrigination.
		self.extraPmtGrowthCalc	= [DateSensitiveValueVariableRateCalculatorCreator
			createVariableRateCalc:loan.extraPmtGrowthRate.growthRate
			andStartDate:self.simParams.simStartDate andScenario:simParams.simScenario
			andUseLoanAnnualRates:false];
	
		self.loanBalance = [self configLoanBalance];
			
		[simParams.digestSums addDigestSum:self.loanBalance.accruedInterest];
			
			
		
	}
	return self;
}



-(id)init
{
	assert(0); // must unit with Loan
	return nil;
}


@end
