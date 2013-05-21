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

@implementation LoanSimInfo

@synthesize loan;
@synthesize loanBalance;
@synthesize extraPmtGrowthCalc;
@synthesize simParams;

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

	double extraPmtAsOfDate = 
		[SimInputHelper multiScenValueAsOfDate:self.loan.extraPmtAmt.amount andDate:pmtDate
				andScenario:simParams.simScenario];
	
	double extraPmtGrowthSinceSimStart = [self.extraPmtGrowthCalc valueMultiplierForDate:pmtDate];
	
	extraPmtAsOfDate = extraPmtAsOfDate * extraPmtGrowthSinceSimStart;
		
	return extraPmtAsOfDate;
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


- (double)monthlyPayment
{

	// TODO - The code below calculates the monthly payment using the loan origination
	// amount and the fixed interest rates as of the loan origination date.
	double annualInterestRateAsOfLoanOrig = 
		[SimInputHelper multiScenValueAsOfDate:self.loan.interestRate.growthRate 
			andDate:[self loanOrigDate] andScenario:simParams.simScenario]/100.0;
	assert(annualInterestRateAsOfLoanOrig >= 0.0);

// TBD  Need to reconcile to 2 methods below for calculating the monthly payment.
// Simply dividing by 12 seems to be the standard, the first (commented out) one is for the APY
// and arguably more correct/precise.
//		double monthlyInterestRateAsOfLoanOrig = [
//			VariableRate annualRateToPerPeriodRate:annualInterestRateAsOfLoanOrig 
//			andNumPeriods:12.0];

	double monthlyInterestRateAsOfLoanOrig = annualInterestRateAsOfLoanOrig / 12.0;


	// TODO - Adjust the payment amount if the payments are deferred.
	double startingBal = [self startingBalanceAfterDownPayment];
	
	double payment = [VariableRate periodicPaymentForPrincipal:startingBal
			andPeriodRate:monthlyInterestRateAsOfLoanOrig andNumPeriods:[self loanTermMonths]];
	assert(payment >= 0.0);
	
	return payment;
}




- (EventRepeater*)createLoanPmtRepeater
{
	EventRepeater *pmtRepeater = [self createLoanEventRepeater];
	assert(pmtRepeater != nil);
	
	// The first payment always happens one month after origination.
	[pmtRepeater nextDate];

	return pmtRepeater;	
}


- (NSDate*)calcInterestStartDate
{
	if([self loanOriginatesAfterSimStart])
	{
		// Loan originates in the the future w.r.t. the sim start date
		return [self loanOrigDate];
	}
	else
	{
		// Loan originates in the past w.r.t. the sim start date.
		EventRepeater *pmtRepeater = [self createLoanEventRepeater];
		NSDate *paymentInterestStartDate = pmtRepeater.startDate;

		// Loan exists as of the start date. Interest starts on the last
		// payment date before the sim start date.
		NSDate *pmtDate = [pmtRepeater nextDate];
		assert(pmtDate != nil);
// TODO - Need to test for boundary case where first pmt is on the simulation start date.
		while([DateHelper dateIsLater:self.simParams.simStartDate otherDate:pmtDate])
		{
			// If we get to here, the payment date is still before
			// the start of simulation date. We keep on updating
			// paymentInterestStartDate until the payment date is
			// after the simulation start date.
			paymentInterestStartDate = pmtDate;

			pmtDate = [pmtRepeater nextDate];
			assert(pmtDate != nil);
			
		}
		return paymentInterestStartDate;
	}

}


-(double)simulatedStartingBalanceForPastLoanOrigination
{
	double startingBalAtLoanOrig = [self startingBalanceAfterDownPayment];
	NSDate *loanOrigDate = [self loanOrigDate];
	
	// If early payoff is enabled and is before the sim start, then
	// the starting balance is always 0.0, since the loan was paid
	// off before the simulation start.
	if([self earlyPayoffAfterOrigination] &&
			(![self earlyPayoffAfterSimStart]))
	{
		return 0.0;
	}

	
	// TBD - What do we do about extra payments?
	
	VariableRateCalculator *interestRateCalc = [DateSensitiveValueVariableRateCalculatorCreator 
		createVariableRateCalc:self.loan.interestRate.growthRate 
		andStartDate:loanOrigDate andScenario:self.simParams.simScenario
		andUseLoanAnnualRates:true];
				
	InterestBearingWorkingBalance *loanBalanceBeforeSimStart = [[[InterestBearingWorkingBalance alloc]
		initWithStartingBalance:startingBalAtLoanOrig andInterestRateCalc:interestRateCalc 
		andWorkingBalanceName:self.loan.name andWithdrawPriority:WORKING_BALANCE_WITHDRAW_PRIORITY_MAX] autorelease];
	double balanceAsOfLastPaymentBeforeSimStart = [loanBalanceBeforeSimStart currentBalanceForDate:loanOrigDate];
	
	EventRepeater *pmtRepeater = [self createLoanPmtRepeater];
	double monthlyPmt = [self monthlyPayment];

	// Loan exists as of the start date. Interest starts on the last
	// payment date before the sim start date.
	
	NSDate *pmtDate = [pmtRepeater nextDate];
	assert(pmtDate != nil);
	
// TODO - Need to test for boundary case where first pmt is on the simulation start date.
	while([DateHelper dateIsLater:self.simParams.simStartDate otherDate:pmtDate])
	{
		[loanBalanceBeforeSimStart carryBalanceForward:pmtDate];
		[loanBalanceBeforeSimStart decrementAvailableBalanceForNonExpense:monthlyPmt asOfDate:pmtDate];
		balanceAsOfLastPaymentBeforeSimStart = [loanBalanceBeforeSimStart currentBalanceForDate:pmtDate];

		pmtDate = [pmtRepeater nextDate];
		assert(pmtDate != nil);
		
	}

	return balanceAsOfLastPaymentBeforeSimStart;
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
		
		
		
		// The working balance is setup with a "starting date for interest" (interestStartDate). This
		// date is either the loan origination date, or the last payment date before the start of simulation
		NSDate *interestStartDate;
		double startingLoanBalance = 0.0;
		
		if([self loanOriginatesAfterSimStart])
		{
			// The loan will occur/originate in the future (w.r.t. to simulation start date):
			//
			// If the origination date is after the simulation start date, then the "starting balance"
			// on the loan should be ignored. This is because the loan will start after the simulation
			// start date, with a balance that is equal to the total amount borrowed.			
			interestStartDate = [self loanOrigDate];
			startingLoanBalance = [self startingBalanceAfterDownPayment];
		}
		else
		{
			// The loan is existing as of the simulation start date:
			//
			// In this case the simulation start date is after the origination date. So,
			// we need to use the "starting balance" for the loan, to account for the all
			// the prior payments already made on the loan (plus any extra payments, etc.)
			// If a starting balance hasn't been provided by the user, then "simulate" the
			// starting balance by computing payments and interest before the simulation
			// start date.
			interestStartDate = [self calcInterestStartDate];
			if(self.loan.startingBalance == nil)
			{
				startingLoanBalance = [self simulatedStartingBalanceForPastLoanOrigination];
			}
			else
			{
				startingLoanBalance = [self.loan.startingBalance doubleValue];
			}
		}
		
		assert(interestStartDate != nil);
		assert(startingLoanBalance >= 0.0);
		
		// Setup the working balance for the loan principal.
// TBD - should the start date be interest start date or simulation start
		VariableRateCalculator *interestRateCalc = [DateSensitiveValueVariableRateCalculatorCreator 
			createVariableRateCalc:self.loan.interestRate.growthRate 
			andStartDate:interestStartDate andScenario:simParams.simScenario 
			andUseLoanAnnualRates:true];				
		self.loanBalance = [[[InterestBearingWorkingBalance alloc] 
			initWithStartingBalance:startingLoanBalance andInterestRateCalc:interestRateCalc 
			andWorkingBalanceName:self.loan.name andWithdrawPriority:WORKING_BALANCE_WITHDRAW_PRIORITY_MAX] autorelease];
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
