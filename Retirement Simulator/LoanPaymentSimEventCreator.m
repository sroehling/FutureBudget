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
#import "RegularPmtProcessor.h"
#import "InterestOnlyPmtProcessor.h"
#import "NoPmtProcessor.h"
#import "FirstDeferredPmtProcessor.h"

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
	
	hasDeferredPayments = [self.loanInfo deferredPaymentDateEnabled];
	interestSubsizedUnderDeferrment = [self.loanInfo deferredPaymentInterestSubsidized];
	payInterestUnderDeferrment = [self.loanInfo deferredPaymentPayInterestWhileInDeferrment];
	
	firstPaymentMadeUnderDeferrment = FALSE;
		
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
		
		if(hasDeferredPayments)
		{
			if([self.loanInfo beforeDeferredPaymentDate:nextPmtDate])
			{
				if(payInterestUnderDeferrment)
				{
					pmtEvent.pmtProcessor = [[[InterestOnlyPmtProcessor alloc]
						initWithSubsidizedInterestPayment:interestSubsizedUnderDeferrment] autorelease];
				}
				else
				{
					pmtEvent.pmtProcessor = [[[NoPmtProcessor alloc] init] autorelease];
				}
			}
			else
			{
				if([self.loanInfo beforeDeferredPaymentDate:self.loanInfo.simParams.simStartDate])
				{
					if(!firstPaymentMadeUnderDeferrment)
					{
						pmtEvent.pmtProcessor = [[[FirstDeferredPmtProcessor alloc] init] autorelease];;
						firstPaymentMadeUnderDeferrment = TRUE;
					}
					else
					{
						pmtEvent.pmtProcessor = [[[RegularPmtProcessor alloc] init] autorelease];;
					}
				}
				else
				{
						pmtEvent.pmtProcessor = [[[RegularPmtProcessor alloc] init] autorelease];;
				}
							
				
			}
		}
		else
		{
			pmtEvent.pmtProcessor = [[[RegularPmtProcessor alloc]init] autorelease];
		}
		
		pmtEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_LOAN_PMT;
		
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
