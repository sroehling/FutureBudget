//
//  EstimatedTaxPaymentSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EstimatedTaxPaymentSimEventCreator.h"
#import "EstimatedTaxPaymentSimEvent.h"

@implementation EstimatedTaxPaymentSimEventCreator

- (SimEvent*)createSimEventOnDate:(NSDate*)eventDate
{
	EstimatedTaxPaymentSimEvent *theEvent = [[[EstimatedTaxPaymentSimEvent alloc]initWithEventCreator:self 
			andEventDate:eventDate ] autorelease];
	theEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_LOW;
	return theEvent;
}


@end
