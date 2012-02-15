//
//  EventListTest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventListTest.h"
#import "TestSimEvent.h"
#import "TestSimEventCreator.h"
#import "DateHelper.h"
#import "SimEventList.h"

@implementation EventListTest

@synthesize eventList;
@synthesize eventCreator;

- (void)setUp
{
	self.eventCreator = [[[TestSimEventCreator alloc] init] autorelease];
	self.eventList = [[[SimEventList alloc] init] autorelease];
}

- (void)tearDown
{
}

- (void)addEvent:(NSDate*)eventDate withPriority:(NSInteger)priority andLabel:(NSString*)lbl
{
	assert(eventDate != nil);
	TestSimEvent *theEvent = [[TestSimEvent alloc]initWithEventCreator:self.eventCreator  
		andEventDate:eventDate];
	theEvent.eventLabel = lbl;
	theEvent.tieBreakPriority = priority;
	[eventList addEvent:theEvent];
}


-(void)checkNextEvent:(NSString*)expectedLabel
{
	TestSimEvent *nextEvent = (TestSimEvent*)[self.eventList nextEvent];
	STAssertNotNil(nextEvent, @"Expecting event from list, got nil (end of event list");
	STAssertEqualObjects(expectedLabel,nextEvent.eventLabel,@"checkNextEvent: Expecting label %@, got %@",
			expectedLabel,nextEvent.eventLabel);
	NSLog(@"checkNextEvent: Expecting label %@, got %@",expectedLabel,nextEvent.eventLabel);
}

-(void)checkLastEvent
{
	TestSimEvent *theEvent =  (TestSimEvent*)[self.eventList nextEvent];
	STAssertNil(theEvent,@"Expecting last (nil) event, got a non-nil event %@",theEvent.eventLabel);
}


- (void)testMultiDayEventList 
{
	[self.eventList removeAllEvents];

	[self addEvent:[DateHelper beginningOfDay:[DateHelper dateFromStr:@"2011-01-01"]]
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_LOW andLabel:@"D1"];
	[self addEvent:[DateHelper beginningOfDay:[DateHelper dateFromStr:@"2012-04-15"]]
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_LOW andLabel:@"D3"];
	[self addEvent:[DateHelper beginningOfDay:[DateHelper dateFromStr:@"2011-01-02"]] 
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_LOW andLabel:@"D2"];

	[self checkNextEvent:@"D1"];
	[self checkNextEvent:@"D2"];
	[self checkNextEvent:@"D3"];
	[self checkLastEvent];
	
}


- (void)testSimpleEventList 
{
	[self.eventList removeAllEvents];

	[self addEvent:[DateHelper beginningOfDay:[DateHelper dateFromStr:@"2011-01-01"]]
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_LOW andLabel:@"D1_PL"];
	[self addEvent:[DateHelper beginningOfDay:[DateHelper dateFromStr:@"2011-01-01"]] 
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_HIGHEST andLabel:@"D1_PH"];
	[self addEvent:[DateHelper beginningOfDay:[DateHelper dateFromStr:@"2011-01-01"]]
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_MEDIUM andLabel:@"D1_PM"];

	[self checkNextEvent:@"D1_PH"];
	[self checkNextEvent:@"D1_PM"];
	[self checkNextEvent:@"D1_PL"];
	[self checkLastEvent];
	
}

-(void)dealloc
{
	[eventList release];
	[eventCreator release];
	[super dealloc];
}

@end
