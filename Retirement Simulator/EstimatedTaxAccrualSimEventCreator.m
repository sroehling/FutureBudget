//
//  EstimatedTaxAccrualSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EstimatedTaxAccrualSimEventCreator.h"
#import "EstimatedTaxAccrualSimEvent.h"

@implementation EstimatedTaxAccrualSimEventCreator

- (SimEvent*)createSimEventOnDate:(NSDate*)eventDate
{
	EstimatedTaxAccrualSimEvent *theEvent = [[[EstimatedTaxAccrualSimEvent alloc]initWithEventCreator:self 
			andEventDate:eventDate ] autorelease];
	theEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_MEDIUM_LOW;
	return theEvent;
}


@end
