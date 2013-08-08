//
//  DownPaymentSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanOrigSimEventCreator.h"
#import "SimInputHelper.h"
#import "LoanInput.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "SharedAppValues.h"
#import "ExpenseSimEvent.h"
#import "LoanOrigSimEvent.h"
#import "DateHelper.h"
#import "LoanSimInfo.h"

@implementation LoanOrigSimEventCreator

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

- (id) init
{
	assert(0); 
	return 0;
}


- (void)resetSimEventCreation
{
    origEventCreated = false;
	
}

- (SimEvent*)nextSimEvent
{
	if(origEventCreated)
	{
		return nil;
	}
	origEventCreated = true;
	
	if([self.loanInfo loanOriginatesAfterSimStart])
	{
		LoanOrigSimEvent *origEvent = [[[LoanOrigSimEvent alloc] initWithEventCreator:self 
			andEventDate:[self.loanInfo loanOrigDate] 
			andLoanInfo:self.loanInfo] autorelease];
        origEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_LOAN_ORIG;
		return origEvent;
	}
	else
	{
		// No need to process the loan origination, since the simulation start date is after the 
		// loan origination. The receipt of money's for the loan and down payment will 
		// already be "baked into" the starting
		// values of accounts and the loan principal.
		return nil;
	}
}



- (void) dealloc
{
	[loanInfo release];
	[super dealloc];
}

@end
