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
#import "SimInputHelper.h"
#import "LoanSimInfo.h"
#import "SimParams.h"
#import "RegularPaymentAmtCalculator.h"

@implementation LoanPaymentSimEventCreator

@synthesize eventRepeater;
@synthesize loanInfo;


- (id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo
{
	self = [super init];
	if(self)
	{
		assert(theLoanInfo != nil);
		self.loanInfo = theLoanInfo;
		
	}
	return self;

}

- (void)resetSimEventCreation
{
	// createLoanPmtRepeater will start the payments one month after origination.
    self.eventRepeater = [self.loanInfo createLoanPmtRepeater];
	
	monthlyPayment = [self.loanInfo monthlyPayment];
	assert(monthlyPayment >= 0.0);

	
}

- (SimEvent*)nextSimEvent
{
    assert(eventRepeater!=nil);
	
    NSDate *nextPmtDate = [eventRepeater nextDateOnOrAfterDate:self.loanInfo.simParams.simStartDate];
    if(nextPmtDate !=nil)
	{
		LoanPaymentSimEvent *pmtEvent = [[[LoanPaymentSimEvent alloc]initWithEventCreator:self 
			andEventDate:nextPmtDate ] autorelease];
		pmtEvent.loanInfo = self.loanInfo;
		pmtEvent.pmtCalculator = [[[RegularPaymentAmtCalculator alloc] init] autorelease];
		
		return pmtEvent;
	}
	else
	{
		return nil; // done paying off loan
	}
}


- (void)dealloc {
    // release owned objects here
	[eventRepeater release];
	[loanInfo release];
    [super dealloc]; // pretty important.

}


@end
