//
//  LoanPaymentSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanPaymentSimEventCreator.h"
#import "CashWorkingBalance.h"
#import "LoanInput.h"
#import "SimDate.h"
#import "MultiScenarioInputValue.h"
#import "ValueAsOfCalculator.h"
#import "VariableRateCalculator.h"
#import "EventRepeater.h"
#import "DateHelper.h"
#import "SharedAppValues.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "ValueAsOfCalculatorCreator.h"
#import "NeverEndDate.h"
#import "VariableRate.h"
#import "InterestBearingWorkingBalance.h"
#import "DateHelper.h"
#import "LoanPaymentSimEvent.h"
#import "FixedValue.h"

@implementation LoanPaymentSimEventCreator

@synthesize eventRepeater;
@synthesize loanBalance;
@synthesize loan;


- (double)resolveValueAsOfDate:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	andDate:(NSDate*)resolveDate
{
	assert(resolveDate != nil);
	id<ValueAsOfCalculator> amtCalc = [ValueAsOfCalculatorCreator createValueAsOfCalc:multiScenDateSensitiveVal];
	double valAsOfDate = [amtCalc valueAsOfDate:resolveDate];
	return valAsOfDate;

}


- (NSDate*)resolveMultiScenFixedDate:(MultiScenarioInputValue*)multiScenDate
{
	assert(multiScenDate != nil);
	SimDate *simDate = (SimDate*)[multiScenDate getValueForCurrentOrDefaultScenario];
	assert(simDate != nil);
	assert(simDate.date != nil);
	return simDate.date;
}

- (double)resolveMultiScenFixedVal:(MultiScenarioInputValue*)multiScenVal
{
	assert(multiScenVal != nil);
	FixedValue *fixedVal = (FixedValue*)[multiScenVal getValueForCurrentOrDefaultScenario];
	assert(fixedVal != nil);
	assert(fixedVal.value != nil);
	return [fixedVal.value doubleValue];
}

- (NSDate*)loanOrigDate
{
	return [self resolveMultiScenFixedDate:self.loan.multiScenarioOrigDate];
}


- (EventRepeater*)createLoanPmtRepeater
{

	// An event repeater is set up for monthly payments. It repeats indefinitely,
	// because the principal reaching 0 is used to stop event repeating, not
	// a fixed number of repetitions.
	NSDate *resolvedStartDate = [self loanOrigDate];
	NSDate *resolvedEndDate = [SharedAppValues singleton].sharedNeverEndDate.date;
	
	NSLog(@"Loan origination date: date = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:resolvedStartDate]);

	NSDateComponents *monthlyLoanPmtOffset = [[[NSDateComponents alloc] init] autorelease];
	[monthlyLoanPmtOffset setMonth:1];
	
    EventRepeater *pmtRepeater = [[[EventRepeater alloc] 
                     initWithRepeatOffset:monthlyLoanPmtOffset andRepeatOnce:FALSE 
					andStartDate:resolvedStartDate andEndDate:resolvedEndDate] autorelease];
	return pmtRepeater;
}

- (NSDate*)calcInterestStartDate
{
	NSDate *loanOrigDate = [self loanOrigDate];
	NSDate *simStartDate = [[SharedAppValues singleton] beginningOfSimStartDate];

	if([DateHelper dateIsLater:simStartDate otherDate:loanOrigDate])
	{
	
		EventRepeater *pmtRepeater = [self createLoanPmtRepeater];
		NSDate *paymentInterestStartDate = pmtRepeater.startDate;

		// Loan exists as of the start date. Interest starts on the last
		// payment date before the sim start date.
		NSDate *pmtDate = [pmtRepeater nextDate];
		assert(pmtDate != nil);
// TODO - Need to test for boundary case where first pmt is on the simulation start date.
		while([DateHelper dateIsLater:simStartDate otherDate:pmtDate])
		{
			// If we get to here, the payment date is still before
			// the start of simulation date. We keep on updating
			// paymentInterestStartDate until the payment date is
			// after the simulation start date.
			paymentInterestStartDate = pmtDate;

			pmtDate = [self.eventRepeater nextDate];
			assert(pmtDate != nil);
			
		}
		return paymentInterestStartDate;
	}
	else
	{
		// Loan originates in the the future w.r.t. the sim start date
		return loanOrigDate;
	}
}


- (id)initWithLoan:(LoanInput*)theLoan
{
	self = [super init];
	if(self)
	{
		assert(theLoan != nil);
		self.loan = theLoan;

		// Get the loan origination cost (i.e. the amount borrowed). If the loan is in the future,
		// this is possibly adjusted for inflation and variations from the user 
		NSDate *resolvedLoanOrigDate = [self loanOrigDate];
		NSDate *simStartDate = [[SharedAppValues singleton] beginningOfSimStartDate];
		
		// The working balance is setup with a "starting date for interest" (interestStartDate). This
		// date is either the loan origination date, or the last payment date before the start of simulation
		NSDate *interestStartDate;
		double startingLoanBalance = 0.0;
		
		if([DateHelper dateIsLater:simStartDate otherDate:resolvedLoanOrigDate])
		{
			// Loan is existig as of the simulation start date:
			// In this case the simulation start date is after the origination date. So,
			// we need to use the "starting balance" for the loan, to account for the all
			// the prior payments already made on the loan (plus any extra payments, etc.)
			interestStartDate = [self calcInterestStartDate];
			startingLoanBalance = [loan.startingBalance doubleValue];
		}
		else
		{
			// Loan will occur in the future (w.r.t. to simulation start date):
			// If the origination date is after the simulatiion start date, then the "starting balance"
			// on the loan should be ignored. This is because the loan will start after the simulation
			// start date, with a balance that is equal to the total amount borrowed.			
			interestStartDate = resolvedLoanOrigDate;
			startingLoanBalance = 
				[self resolveValueAsOfDate:self.loan.multiScenarioLoanCostAmt andDate:resolvedLoanOrigDate];
		}
		assert(interestStartDate != nil);
		assert(startingLoanBalance >= 0.0);
		
		// Setup the working balance for the loan principal.
		VariableRateCalculator *interestRateCalc = [DateSensitiveValueVariableRateCalculatorCreator 
			createVariableRateCalc:self.loan.multiScenarioInterestRate 
			andStartDate:interestStartDate];				
		self.loanBalance = [[[InterestBearingWorkingBalance alloc] 
			initWithStartingBalance:startingLoanBalance andInterestRateCalc:interestRateCalc 
			andWorkingBalanceName:loan.name andTaxWithdrawals:FALSE 
			andTaxInterest:[loan.taxableInterest boolValue]] autorelease];

		// Calculate the monthly payment, based upon the loan origination amount and interest rate.
		double loanOrigAmount = [self resolveValueAsOfDate:self.loan.multiScenarioLoanCostAmt 
			andDate:resolvedLoanOrigDate];
		
		double annualInterestRateAsOfLoanOrig = [self resolveValueAsOfDate:self.loan.multiScenarioInterestRate 
						andDate:resolvedLoanOrigDate]/100.0;
		assert(annualInterestRateAsOfLoanOrig >= 0.0);
		
// TBD  Need to reconcile to 2 methods below for calculating the monthly payment.
// Simply dividing by 12 seems to be the standard, the first (commented out) one is for the APY
// and arguably more correct/precise.
//		double monthlyInterestRateAsOfLoanOrig = [
//			VariableRate annualRateToPerPeriodRate:annualInterestRateAsOfLoanOrig 
//			andNumPeriods:12.0];
			
		double monthlyInterestRateAsOfLoanOrig = annualInterestRateAsOfLoanOrig / 12.0;
		
		double loanTermMonths = [self resolveMultiScenFixedVal:loan.multiScenarioLoanDuration];
		assert(loanTermMonths > 0.0);
						
		monthlyPayment = [VariableRate periodicPaymentForPrincipal:loanOrigAmount
			andPeriodRate:monthlyInterestRateAsOfLoanOrig andNumPeriods:loanTermMonths];
		assert(monthlyPayment >= 0.0);
	}
	return self;

}

- (void)resetSimEventCreation
{
    self.eventRepeater = [self createLoanPmtRepeater];
	// The first payment always happens one month after origination.
	[self.eventRepeater nextDate];
	
}

- (SimEvent*)nextSimEvent
{
    assert(eventRepeater!=nil);
    assert(eventRepeater!=nil);
    NSDate *nextPmtDate = [eventRepeater nextDateOnOrAfterDate:[[SharedAppValues singleton] beginningOfSimStartDate]];
    if(nextPmtDate !=nil)
	{
		LoanPaymentSimEvent *pmtEvent = [[[LoanPaymentSimEvent alloc]initWithEventCreator:self 
			andEventDate:nextPmtDate ] autorelease];
		pmtEvent.paymentAmt = monthlyPayment;
		pmtEvent.loanBalance = self.loanBalance;
		
		return pmtEvent;
	}
	else
	{
		return nil; // done paying off loan
	}
}


- (void)dealloc {
    // release owned objects here
    [super dealloc]; // pretty important.
	[eventRepeater release];
	[loanBalance release];
	[loan release];

}


@end
