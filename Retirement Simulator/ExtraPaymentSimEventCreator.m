//
//  ExtraPaymentSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExtraPaymentSimEventCreator.h"

#import "EventRepeater.h"
#import "LoanSimInfo.h"
#import "SharedAppValues.h"
#import "LoanPaymentSimEvent.h"
#import "SimParams.h"
#import "ExtraLoanPmtProcessor.h"


@implementation ExtraPaymentSimEventCreator

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
    self.eventRepeater = [self.loanInfo createLoanPmtRepeater];
}

- (SimEvent*)nextSimEvent
{
    assert(eventRepeater!=nil);
	;
    NSDate *nextPmtDate = [eventRepeater nextDateOnOrAfterDate:self.loanInfo.simParams.simStartDate];
    if(nextPmtDate !=nil)
	{
		double extraPayment = [self.loanInfo extraPmtAmountAsOfDate:nextPmtDate];
		if(extraPayment > 0.0)
		{
			LoanPaymentSimEvent *pmtEvent = [[[LoanPaymentSimEvent alloc]initWithEventCreator:self 
				andEventDate:nextPmtDate ] autorelease];
			
			pmtEvent.loanInfo = self.loanInfo;
			pmtEvent.pmtProcessor = [[[ExtraLoanPmtProcessor alloc] init] autorelease];
			
			return pmtEvent;
		}
		else
		{
			// No need to generate the event, since the payment amount is zero.
			return nil;
		}
	}
	else
	{
		return nil; // done paying off loan
	}
}


-(void)dealloc
{
	[eventRepeater release];
	[loanInfo release];
	[super dealloc];
}

@end
