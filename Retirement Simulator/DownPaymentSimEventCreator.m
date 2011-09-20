//
//  DownPaymentSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownPaymentSimEventCreator.h"
#import "SimInputHelper.h"
#import "LoanInput.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "SharedAppValues.h"
#import "ExpenseSimEvent.h"
#import "DateHelper.h"
#import "LoanSimInfo.h"

@implementation DownPaymentSimEventCreator

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
    downPmtEventCreated = false;
	
}

- (SimEvent*)nextSimEvent
{
	if(downPmtEventCreated)
	{
		return nil;
	}
	downPmtEventCreated = true;
	
	if([self.loanInfo loanOriginatesAfterSimStart])
	{
		// Since the loan origination occurs after the simulation start date (i.e. in the future), 
		// so the down payment needs to be adjusted for inflation. 
		double downPmtAmount = [self.loanInfo downPaymentAmount];
	
		if(downPmtAmount > 0)
		{
			ExpenseSimEvent *downPmtEvent = [[[ExpenseSimEvent alloc] initWithEventCreator:self 
				andEventDate:[self.loanInfo loanOrigDate] 
				andAmount:downPmtAmount andIsTaxable:TRUE] autorelease];
			return downPmtEvent;
		}
		else
		{
			return nil;
		}
			
			
	}
	else
	{
		// No need to process the down payment, since the simulation start date is after the 
		// loan origination, so the down payment will already be "baked into" the starting
		// values of accounts and the loan principal.
		return nil;
	}
}



- (void) dealloc
{
	[super dealloc];
	[loanInfo release];
}

@end
