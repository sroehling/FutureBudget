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
@synthesize dateHelper;

-(void)dealloc
{
    [eventList release];
    [eventCreator release];
    [dateHelper release];
    
    [super dealloc];
}


- (void)setUp
{
	self.eventCreator = [[[TestSimEventCreator alloc] init] autorelease];
	self.eventList = [[[SimEventList alloc] init] autorelease];
    self.dateHelper = [[[DateHelper alloc] init] autorelease];
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

	[self addEvent:[self.dateHelper beginningOfDay:[self.dateHelper dateFromStr:@"2011-01-01"]]
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_LOW andLabel:@"D1"];
	[self addEvent:[self.dateHelper beginningOfDay:[self.dateHelper dateFromStr:@"2012-04-15"]]
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_LOW andLabel:@"D3"];
	[self addEvent:[self.dateHelper beginningOfDay:[self.dateHelper dateFromStr:@"2011-01-02"]] 
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_LOW andLabel:@"D2"];

	[self checkNextEvent:@"D1"];
	[self checkNextEvent:@"D2"];
	[self checkNextEvent:@"D3"];
	[self checkLastEvent];
	
}


- (void)testSimpleEventList 
{
	[self.eventList removeAllEvents];

	[self addEvent:[self.dateHelper beginningOfDay:[self.dateHelper dateFromStr:@"2011-01-01"]]
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_LOW andLabel:@"D1_PL"];
	[self addEvent:[self.dateHelper beginningOfDay:[self.dateHelper dateFromStr:@"2011-01-01"]] 
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_HIGHEST andLabel:@"D1_PH"];
	[self addEvent:[self.dateHelper beginningOfDay:[self.dateHelper dateFromStr:@"2011-01-01"]]
		withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_MEDIUM andLabel:@"D1_PM"];

	[self checkNextEvent:@"D1_PH"];
	[self checkNextEvent:@"D1_PM"];
	[self checkNextEvent:@"D1_PL"];
	[self checkLastEvent];
	
}

-(NSDate*)tieBreakDateFromString:(NSString*)dateStrWithHour
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd-HH"];
	NSDate *theDate = [dateFormatter dateFromString:dateStrWithHour];
	assert(theDate != nil);
	return theDate;
}


- (void)testEventListWithTieBreakAndDayResolution
{
	[self.eventList removeAllEvents];
    
	[self addEvent:[self tieBreakDateFromString:@"2011-01-01-02"]
      withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_LOW andLabel:@"D1_PL"];

    // Even if event comes later in the day, it should be normalized to the same day
    // and the event with higher priority should come first.
	[self addEvent:[self tieBreakDateFromString:@"2011-01-01-09"]
      withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_HIGHEST andLabel:@"D1_PH"];
    
    // Two event with the same tie break priority should happen on the same day.
	[self addEvent:[self tieBreakDateFromString:@"2011-01-01-04"]
      withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_LOW andLabel:@"D1_PL"];
    
    // The event with medium priority happens at the same time as the 2nd event
    // with a low priority, but it should come before both events with low
    // priority.
    [self addEvent:[self tieBreakDateFromString:@"2011-01-01-04"]
      withPriority:SIM_EVENT_TIE_BREAK_PRIORITY_MEDIUM andLabel:@"D1_PM"];

    
	[self checkNextEvent:@"D1_PH"];
	[self checkNextEvent:@"D1_PM"];
	[self checkNextEvent:@"D1_PL"];
	[self checkNextEvent:@"D1_PL"];
    
	[self checkLastEvent];
	
}


@end
