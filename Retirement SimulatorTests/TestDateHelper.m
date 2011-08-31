//
//  TestDateHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestDateHelper.h"
#import "DateHelper.h"

@implementation TestDateHelper

- (void)checkOffsetedDate:(NSDate*)offsetDate expectedDateStr:(NSString*)expectedDateStr
{
	STAssertNotNil(offsetDate, @"checkNextDate: Expecting a date %@, got nil", expectedDateStr);
	NSString *offsetDateStr = [DateHelper stringFromDate:offsetDate];
	
	STAssertEqualObjects(expectedDateStr,offsetDateStr,@"checkOffsetedDate: Expecting date %@, got %@",
				expectedDateStr,offsetDateStr);
	NSLog(@"checkNextDate: Expecting date %@, got %@",expectedDateStr,offsetDateStr);
}

- (void)testSameYearDifferentDay
{
	NSDate *baseDate = [DateHelper dateFromStr:@"2011-01-01"];

	[self checkOffsetedDate:[DateHelper 
		sameYearDifferentDay:baseDate andMonth:12 andDay:31] expectedDateStr:@"2011-12-31"];
	[self checkOffsetedDate:[DateHelper 
		sameYearDifferentDay:baseDate andMonth:4 andDay:15] expectedDateStr:@"2011-04-15"];
	[self checkOffsetedDate:[DateHelper 
		sameYearDifferentDay:baseDate andMonth:9 andDay:15] expectedDateStr:@"2011-09-15"];
	[self checkOffsetedDate:[DateHelper 
		sameYearDifferentDay:baseDate andMonth:1 andDay:1] expectedDateStr:@"2011-01-01"];
	
	
}

- (void)testOffsetDates {
    
	NSDate *baseDate = [DateHelper dateFromStr:@"2011-01-01"];
	[self checkOffsetedDate:[DateHelper beginningOfYear:baseDate]		expectedDateStr:@"2011-01-01"];
	[self checkOffsetedDate:[DateHelper beginningOfNextYear:baseDate]	expectedDateStr:@"2012-01-01"];
	[self checkOffsetedDate:[DateHelper endOfYear:baseDate]				expectedDateStr:@"2011-12-31"];

	baseDate = [DateHelper dateFromStr:@"2011-12-31"];
	[self checkOffsetedDate:[DateHelper beginningOfYear:baseDate]		expectedDateStr:@"2011-01-01"];
	[self checkOffsetedDate:[DateHelper beginningOfNextYear:baseDate]	expectedDateStr:@"2012-01-01"];
	[self checkOffsetedDate:[DateHelper endOfYear:baseDate]				expectedDateStr:@"2011-12-31"];


	baseDate = [DateHelper dateFromStr:@"2011-8-31"];
	[self checkOffsetedDate:[DateHelper beginningOfYear:baseDate]		expectedDateStr:@"2011-01-01"];
	[self checkOffsetedDate:[DateHelper beginningOfNextYear:baseDate]	expectedDateStr:@"2012-01-01"];
	[self checkOffsetedDate:[DateHelper endOfYear:baseDate]				expectedDateStr:@"2011-12-31"];


}


@end
