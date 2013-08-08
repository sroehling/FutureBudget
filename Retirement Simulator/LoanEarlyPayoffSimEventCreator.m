//
//  LoanEarlyPayoffSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoanEarlyPayoffSimEventCreator.h"
#import "LoanEarlyPayoffSimEvent.h"
#import "LoanSimInfo.h"


@implementation LoanEarlyPayoffSimEventCreator

@synthesize loanInfo;


- (id)initWithLoanInfo:(LoanSimInfo*)theLoanInfo
{
	self = [super init];
	if(self)
	{
		assert(theLoanInfo != nil);
		self.loanInfo = theLoanInfo;
		eventCreated = false;
	}
	return self;
}

- (void)resetSimEventCreation
{
	eventCreated = false;
}

- (SimEvent*)nextSimEvent
{
	if(eventCreated)
	{
		return nil;
	}
	else
	{
		eventCreated = true;
		
		if([self.loanInfo earlyPayoffAfterOrigination] &&
			[self.loanInfo earlyPayoffAfterSimStart])
		{
			LoanEarlyPayoffSimEvent *payoffEvent = [[[LoanEarlyPayoffSimEvent alloc] 
				initWithLoanInfo:self.loanInfo 
				andEventCreator:self andEventDate:self.loanInfo.earlyPayoffDate] autorelease];
            payoffEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_LOAN_PMT;
			return payoffEvent;
		}
		else
		{
			return nil;
		}
	}
}

-(void)dealloc
{
	[loanInfo release];
	[super dealloc];
}



@end
