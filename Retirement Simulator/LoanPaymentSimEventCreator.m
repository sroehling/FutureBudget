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
#import "DateHelper.h"
#import "LoanPaymentSimEvent.h"

@implementation LoanPaymentSimEventCreator

@synthesize interestRateCalc;
@synthesize eventRepeater;
@synthesize loanWorkingBalance;
@synthesize variableInterestRate;
@synthesize loan;
@synthesize paymentInterestStartDate;


- (id<ValueAsOfCalculator>)createValueAsOfCalc:(MultiScenarioInputValue*)multiScenDateSensitiveVal
{
	assert(multiScenDateSensitiveVal != nil);
	ValueAsOfCalculatorCreator *valAsOfCalcCreator = 
			[[[ValueAsOfCalculatorCreator alloc] init] autorelease];
	DateSensitiveValue *dateSensitiveVal = (DateSensitiveValue*)[
			multiScenDateSensitiveVal getValueForCurrentOrDefaultScenario];
	assert(dateSensitiveVal != nil);
	id<ValueAsOfCalculator> valCalc = [valAsOfCalcCreator 
			createForDateSensitiveValue:dateSensitiveVal];
	return valCalc;
}

- (double)resolveValueAsOfDate:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	andDate:(NSDate*)resolveDate
{
	assert(resolveDate != nil);
	id<ValueAsOfCalculator> amtCalc = [self createValueAsOfCalc:multiScenDateSensitiveVal];
	double valAsOfDate = [amtCalc valueAsOfDate:resolveDate];
	return valAsOfDate;

}

-(VariableRateCalculator*)createVariableRateCalc:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	andStartDate:(NSDate*)startDate
{
	DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];
	DateSensitiveValue *dateSensitiveVal = (DateSensitiveValue*)[
				multiScenDateSensitiveVal getValueForCurrentOrDefaultScenario];
	assert(dateSensitiveVal != nil);
	VariableRateCalculator *rateCalc = [calcCreator 
							createForDateSensitiveValue:dateSensitiveVal 
							andStartDate:startDate];
	return rateCalc;

}

- (NSDate*)resolveMultiScenFixedDate:(MultiScenarioInputValue*)multiScenDate
{
	assert(multiScenDate != nil);
	SimDate *simDate = (SimDate*)[multiScenDate getValueForCurrentOrDefaultScenario];
	assert(simDate != nil);
	assert(simDate.date != nil);
	return simDate.date;
}


- (id)initWithLoanWorkingBalance:(CashWorkingBalance*)theWorkingBalance
	andLoan:(LoanInput*)theLoan
{
	self = [super init];
	if(self)
	{
		self.loanWorkingBalance = theWorkingBalance;
	
		assert(theLoan != nil);
		self.loan = theLoan;

		// Create the rate calculator for the loan's interest

		// Get the loan origination cost (i.e. the amount borrowed). If the loan is in the future,
		// this is possibly adjusted for inflation and variations from the user 
		NSDate *resolvedLoanOrigDate = [self resolveMultiScenFixedDate:self.loan.multiScenarioOrigDate];

		// The interest rate as of the loan origination date is used to calculate the payment amount.
		// A member variable initialized with this interest rate, so that it can be used as
		// necessary to recalculate the payment as the interest rate changes.
		self.variableInterestRate = [self createValueAsOfCalc:self.loan.multiScenarioInterestRate];

		self.interestRateCalc = [self createVariableRateCalc:self.loan.multiScenarioInterestRate 
			andStartDate:resolvedLoanOrigDate];							

		loanOrigAmount = [self resolveValueAsOfDate:self.loan.multiScenarioLoanCostAmt andDate:resolvedLoanOrigDate];
		unpaidLoanPrincipal = loanOrigAmount;
		
		double annualInterestRateAsOfLoanOrig = [self.variableInterestRate valueAsOfDate:resolvedLoanOrigDate];
		double monthlyInterestRateAsOfLoanOrig = [
			VariableRate annualRateToPerPeriodRate:annualInterestRateAsOfLoanOrig 
			andNumPeriods:12.0];
		
		double loanTermMonths = 30.0; // TODO - Need to replace this with a value from the loan input
		
		monthlyPayment = [VariableRate periodicPaymentForPrincipal:loanOrigAmount
			andPeriodRate:monthlyInterestRateAsOfLoanOrig andNumPeriods:loanTermMonths];
	}
	return self;

}

- (void)resetSimEventCreation
{
	// An event repeater is set up for monthly payments. It repeats indefinitely,
	// because the principal reaching 0 is used to stop event repeating, not
	// a fixed number of repetitions.
	NSDate *resolvedStartDate = [self resolveMultiScenFixedDate:self.loan.multiScenarioOrigDate];
	NSDate *resolvedEndDate = [SharedAppValues singleton].sharedNeverEndDate.date;
	
	NSLog(@"Loan origination date: date = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:resolvedStartDate]);

	NSDateComponents *monthlyLoanPmtOffset = [[[NSDateComponents alloc] init] autorelease];
	[monthlyLoanPmtOffset setMonth:1];
	
    self.eventRepeater = [[EventRepeater alloc] 
                     initWithRepeatOffset:monthlyLoanPmtOffset andRepeatOnce:FALSE 
					andStartDate:resolvedStartDate andEndDate:resolvedEndDate];
	
	// The first payment happens at least 1 month after the start date. The first
	// date also needs to occur after the simulation start date. 
	self.paymentInterestStartDate = resolvedStartDate;
	[self.eventRepeater nextDate];
	
	NSDate *simStartDate = [[SharedAppValues singleton] beginningOfSimStartDate];
	NSDate *nextDateAfterLoanOrigStartDate = [self.eventRepeater nextDate];
	while((nextDateAfterLoanOrigStartDate != nil) && 
		[DateHelper dateIsLater:simStartDate otherDate:nextDateAfterLoanOrigStartDate])
	{
		self.paymentInterestStartDate = nextDateAfterLoanOrigStartDate;
		nextDateAfterLoanOrigStartDate = [self.eventRepeater nextDate];
	}


}

- (SimEvent*)nextSimEvent
{
    assert(eventRepeater!=nil);
	
	if(unpaidLoanPrincipal <= 0.0)
	{
		return nil; // done paying off the loan
	}
	else
	{
		NSDate *nextPaymentDate = [self.eventRepeater nextDate];
		
		assert([DateHelper dateIsEqualOrLater:nextPaymentDate 
			otherDate:[[SharedAppValues singleton] beginningOfSimStartDate]]);
		
		double interestMultiplier = [self.interestRateCalc 
			valueMultiplierBetweenStartDate:self.paymentInterestStartDate andEndDate:nextPaymentDate];
		assert(interestMultiplier >= 1.0);
		double interestAccrued = (interestMultiplier - 1.0) * unpaidLoanPrincipal;

		double interestPayment;
		double principalPayment;
		double interestCarriedForward;
		if(interestAccrued >= monthlyPayment)
		{
			// The interest due is more than the monthly payment. This loan
			// is effectively an "interest only" loan, and no principal is being
			// paid. Any left-over intererest is added to the unpaidPrincipalAmount,
			// and no principal payment is made.
			interestCarriedForward = interestAccrued - monthlyPayment;
			interestPayment = monthlyPayment;
			principalPayment = 0.0;
		}
		else
		{
			// This is the normal case - the interest due is less than the monthly 
			// payment. The interest payed is the same as the amount of interested accrued/due.
			// The principal payment is the monthly payment amount less the interest payment.
			interestCarriedForward = 0.0;
			interestPayment =  interestAccrued;
			principalPayment = monthlyPayment - interestPayment;
		}
		unpaidLoanPrincipal = unpaidLoanPrincipal - principalPayment + interestCarriedForward;
		
		LoanPaymentSimEvent *pmtEvent = [[[LoanPaymentSimEvent alloc]initWithEventCreator:self 
			andEventDate:nextPaymentDate ] autorelease];
		pmtEvent.interestIsTaxable = [self.loan.taxableInterest boolValue];
		pmtEvent.paymentAmt = monthlyPayment;
		pmtEvent.interestAmt = interestAccrued;
		
		
		return pmtEvent;
		
		
	}
}


- (void)dealloc {
    // release owned objects here
    [super dealloc]; // pretty important.
	[eventRepeater release];
	[interestRateCalc release];
	[loanWorkingBalance release];
	[loan release];
	[paymentInterestStartDate release];
}


@end
