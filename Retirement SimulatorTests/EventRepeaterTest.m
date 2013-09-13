//
//  EventRepeaterTest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventRepeaterTest.h"

#import "EventRepeater.h"
#import "DataModelController.h"
#import "EventRepeatFrequency.h"
#import "DateHelper.h"


@implementation EventRepeaterTest

@synthesize coreData;
@synthesize dateHelper;

- (EventRepeatFrequency*)createOneRepeatFrequencyWithPeriod: (EventPeriod)thePeriod andMultiplier:(int)theMultiplier
{
	EventRepeatFrequency *repeatFrequency  = [self.coreData 
		createDataModelObject:EVENT_REPEAT_FREQUENCY_ENTITY_NAME];
    repeatFrequency.period = [NSNumber numberWithInt:thePeriod];
    [repeatFrequency setPeriodWithPeriodEnum:thePeriod];
    repeatFrequency.periodMultiplier = [NSNumber numberWithInt:theMultiplier];
	return repeatFrequency;	
}


- (void)setUp
{
	self.coreData = [[[DataModelController alloc] initForInMemoryStorage] autorelease];
    self.dateHelper = [[[DateHelper alloc] init] autorelease];
}

- (void)tearDown
{
	[coreData release];
    [dateHelper release];
}

- (void)checkNextDate:(EventRepeater*)eventRepeater expectedDateStr:(NSString*)expectedDateStr
{
	NSDate *expectedDate = [self.dateHelper dateFromStr:expectedDateStr];
	NSDate *eventDate = [eventRepeater nextDate];
	NSString *eventDateStr = [self.dateHelper stringFromDate:eventDate];
	STAssertNotNil(eventDate, @"checkNextDate: Expecting a date %@, got nil", expectedDateStr);
	
	STAssertEqualObjects(expectedDate,eventDate,@"checkNextDate: Expecting date %@, got %@",
				expectedDateStr,eventDateStr);
	NSLog(@"checkNextDate: Expecting date %@, got %@",expectedDateStr,eventDateStr);
}

- (void)checkNextNilDate:(EventRepeater*)eventRepeater
{
	NSDate *eventDate = [eventRepeater nextDate];
	STAssertNil(eventDate,@"checkNextDate: Expecting nil, got %@",
				[self.dateHelper stringFromDate:eventDate]);
	NSLog(@"checkNextNilDate: Expecting nil date (end of repeating)");
}

-(void)testOneTimeEventRepeater
{
	EventRepeatFrequency *repeatOnce= [self createOneRepeatFrequencyWithPeriod:kEventPeriodOnce andMultiplier:1];
	NSDate *startDate = [self.dateHelper dateFromStr:@"2011-05-31"];
	NSDate *endDate = [self.dateHelper dateFromStr:@"2100-01-01"];

	EventRepeater *eventRepeater = [[EventRepeater alloc] 
									initWithEventRepeatFrequency:repeatOnce
									andStartDate:startDate andEndDate:endDate];
	[self checkNextDate:eventRepeater expectedDateStr:@"2011-05-31"];
	[self checkNextNilDate:eventRepeater];
}
	
-(void)testYearlyEventRepeaterWithEndDate
{
	EventRepeatFrequency *repeatYearly = [self createOneRepeatFrequencyWithPeriod:kEventPeriodYear andMultiplier:1];
	NSDate *startDate = [self.dateHelper dateFromStr:@"2011-01-01"];
	NSDate *endDate = [self.dateHelper dateFromStr:@"2013-01-01"];
	EventRepeater *eventRepeater = [[EventRepeater alloc] 
                     initWithEventRepeatFrequency:repeatYearly
                     andStartDate:startDate andEndDate:endDate];
	[self checkNextDate:eventRepeater expectedDateStr:@"2011-01-01"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-01-01"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2013-01-01"];				 
	[self checkNextNilDate:eventRepeater];
			 
}

-(void)testYearlyEventRepeater
{
	EventRepeatFrequency *repeatYearly = [self createOneRepeatFrequencyWithPeriod:kEventPeriodYear andMultiplier:1];
	NSDate *startDate = [self.dateHelper dateFromStr:@"2011-01-01"];
	NSDate *endDate = [self.dateHelper dateFromStr:@"2100-01-01"];
	EventRepeater *eventRepeater = [[EventRepeater alloc] 
                     initWithEventRepeatFrequency:repeatYearly
                     andStartDate:startDate andEndDate:endDate];
	[self checkNextDate:eventRepeater expectedDateStr:@"2011-01-01"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-01-01"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2013-01-01"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2014-01-01"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2015-01-01"];				 
}

-(void)testEveryOtherYearRepeater
{
	EventRepeatFrequency *repeatEveryOtherYear = [self 
					createOneRepeatFrequencyWithPeriod:kEventPeriodYear andMultiplier:2];
	NSDate *startDate = [self.dateHelper dateFromStr:@"2011-01-01"];
	NSDate *endDate = [self.dateHelper dateFromStr:@"2100-01-01"];
	EventRepeater *eventRepeater = [[EventRepeater alloc] 
									initWithEventRepeatFrequency:repeatEveryOtherYear
									andStartDate:startDate andEndDate:endDate];
	[self checkNextDate:eventRepeater expectedDateStr:@"2011-01-01"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2013-01-01"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2015-01-01"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2017-01-01"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2019-01-01"];				 
}


-(void)testLeapYearEventRepeater
{
	EventRepeatFrequency *repeatYearly = [self createOneRepeatFrequencyWithPeriod:kEventPeriodYear andMultiplier:1];
	NSDate *startDate = [self.dateHelper dateFromStr:@"2012-02-29"];
	NSDate *endDate = [self.dateHelper dateFromStr:@"2100-01-01"];
	EventRepeater *eventRepeater = [[EventRepeater alloc] 
									initWithEventRepeatFrequency:repeatYearly
									andStartDate:startDate andEndDate:endDate];
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-02-29"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2013-02-28"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2014-02-28"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2015-02-28"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2016-02-28"];				 
}



-(void)testMonthlyEventRepeater
{
	EventRepeatFrequency *repeatMonthly = [self createOneRepeatFrequencyWithPeriod:kEventPeriodMonth andMultiplier:1];
	NSDate *startDate = [self.dateHelper dateFromStr:@"2012-01-15"];
	NSDate *endDate = [self.dateHelper dateFromStr:@"2100-01-01"];

	EventRepeater *eventRepeater = [[EventRepeater alloc] 
									initWithEventRepeatFrequency:repeatMonthly
									andStartDate:startDate andEndDate:endDate];
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-01-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-02-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-03-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-04-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-05-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-06-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-07-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-08-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-09-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-10-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-11-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-12-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2013-01-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2013-02-15"];				 
}
	
	
-(void)testQuarterlyEventRepeater
{
	EventRepeatFrequency *repeatQuarterly = [self createOneRepeatFrequencyWithPeriod:kEventPeriodMonth andMultiplier:3];
	NSDate *startDate = [self.dateHelper dateFromStr:@"2012-01-15"];
	NSDate *endDate = [self.dateHelper dateFromStr:@"2100-01-01"];
	EventRepeater *eventRepeater = [[EventRepeater alloc] 
									initWithEventRepeatFrequency:repeatQuarterly
									andStartDate:startDate andEndDate:endDate];
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-01-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-04-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-07-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2012-10-15"];				 
	[self checkNextDate:eventRepeater expectedDateStr:@"2013-01-15"];				 
			 
}


@end
