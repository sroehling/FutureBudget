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
#import "SharedAppValues.h"
#import "DateHelper.h"
#import "VariableRateCalculator.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "InterestBearingWorkingBalance.h"
#import "EventRepeater.h"
#import "SharedAppValues.h"
#import "NeverEndDate.h"

@implementation LoanSimInfo

@synthesize loan;
@synthesize loanBalance;

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
	if([self loanOriginatesAfterSimStart])
	{
		// Loan originates in the the future w.r.t. the sim start date
		return [self loanOrigDate];
	}
	else
	{
		NSDate *simStartDate = [[SharedAppValues singleton] beginningOfSimStartDate];

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

			pmtDate = [pmtRepeater nextDate];
			assert(pmtDate != nil);
			
		}
		return paymentInterestStartDate;
	}

}


-(id)initWithLoan:(LoanInput*)theLoan
{
	self = [super init];
	if(self)
	{
		assert(theLoan != nil);
		self.loan = theLoan;
		
		
				// The working balance is setup with a "starting date for interest" (interestStartDate). This
		// date is either the loan origination date, or the last payment date before the start of simulation
		NSDate *interestStartDate;
		double startingLoanBalance = 0.0;
		
		if([self loanOriginatesAfterSimStart])
		{
			// Loan will occur in the future (w.r.t. to simulation start date):
			// If the origination date is after the simulatiion start date, then the "starting balance"
			// on the loan should be ignored. This is because the loan will start after the simulation
			// start date, with a balance that is equal to the total amount borrowed.			
			interestStartDate = [self loanOrigDate];
			startingLoanBalance = [self loanOrigAmount];
		}
		else
		{
			// Loan is existing as of the simulation start date:
			// In this case the simulation start date is after the origination date. So,
			// we need to use the "starting balance" for the loan, to account for the all
			// the prior payments already made on the loan (plus any extra payments, etc.)
			interestStartDate = [self calcInterestStartDate];
			startingLoanBalance = [self.loan.startingBalance doubleValue];
		}
		
		assert(interestStartDate != nil);
		assert(startingLoanBalance >= 0.0);
		
		// Setup the working balance for the loan principal.
		VariableRateCalculator *interestRateCalc = [DateSensitiveValueVariableRateCalculatorCreator 
			createVariableRateCalc:self.loan.multiScenarioInterestRate 
			andStartDate:interestStartDate];				
		self.loanBalance = [[[InterestBearingWorkingBalance alloc] 
			initWithStartingBalance:startingLoanBalance andInterestRateCalc:interestRateCalc 
			andWorkingBalanceName:self.loan.name andTaxWithdrawals:FALSE 
			andTaxInterest:[self interestIsTaxable]] autorelease];		

		
		
	}
	return self;
}



-(NSDate*)loanOrigDate
{
	assert(self.loan.multiScenarioOrigDate != nil);
	return [SimInputHelper multiScenFixedDate:self.loan.multiScenarioOrigDate];
}

-(bool)loanOriginatesAfterSimStart;
{
	NSDate *loanOrigDate = [self loanOrigDate];
	NSDate *simStartDate = [[SharedAppValues singleton] beginningOfSimStartDate];
		
	if([DateHelper dateIsEqualOrLater:loanOrigDate otherDate:simStartDate])
	{
		return true;
	}
	else
	{
		return false;
	}

}

- (double)loanOrigAmount
{
	// Calculate the monthly payment, based upon the loan origination amount and interest rate.
	assert(self.loan.multiScenarioLoanCostAmt != nil);
	double origAmount = [SimInputHelper multiScenValueAsOfDate:self.loan.multiScenarioLoanCostAmt 
			andDate:[self loanOrigDate]];
	assert(origAmount >= 0.0);
	return origAmount;
}

-(double)loanTermMonths
{
	assert(loan.multiScenarioLoanDuration != nil);
	double termMonths = [SimInputHelper multiScenFixedVal:loan.multiScenarioLoanDuration];
	assert(termMonths > 0.0);
	return termMonths;
}

- (double)monthlyPayment
{
	double annualInterestRateAsOfLoanOrig = 
		[SimInputHelper multiScenValueAsOfDate:self.loan.multiScenarioInterestRate 
			andDate:[self loanOrigDate]]/100.0;
	assert(annualInterestRateAsOfLoanOrig >= 0.0);

// TBD  Need to reconcile to 2 methods below for calculating the monthly payment.
// Simply dividing by 12 seems to be the standard, the first (commented out) one is for the APY
// and arguably more correct/precise.
//		double monthlyInterestRateAsOfLoanOrig = [
//			VariableRate annualRateToPerPeriodRate:annualInterestRateAsOfLoanOrig 
//			andNumPeriods:12.0];

	double monthlyInterestRateAsOfLoanOrig = annualInterestRateAsOfLoanOrig / 12.0;


	double origAmount = [self loanOrigAmount];
	
	double payment = [VariableRate periodicPaymentForPrincipal:origAmount
			andPeriodRate:monthlyInterestRateAsOfLoanOrig andNumPeriods:[self loanTermMonths]];
	assert(payment >= 0.0);
	
	return payment;
}


-(double)downPaymentPercent
{
	double downPmtPercent = [SimInputHelper 
		multiScenValueAsOfDate:self.loan.multiScenarioDownPmtPercent 
		andDate:[self loanOrigDate]];
	assert(downPmtPercent >= 0.0);
	assert(downPmtPercent <= 100.0);
	return downPmtPercent/100.0;
}

-(double)downPaymentAmount
{
	if([SimInputHelper multiScenBoolVal:self.loan.multiScenarioDownPmtEnabled])
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

-(bool)interestIsTaxable;
{
	assert(loan.taxableInterest != nil);
	return [loan.taxableInterest boolValue];
}

-(id)init
{
	assert(0); // must unit with Loan
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[loan release];
	[loanBalance release];
}

@end
