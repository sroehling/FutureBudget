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

@synthesize dateHelper;

-(void)dealloc
{
    [dateHelper release];
    [super dealloc];
}


- (void)setUp
{
    self.dateHelper = [[[DateHelper alloc] init] autorelease];
    
}

- (void)tearDown
{
	[dateHelper release];
}



- (void)checkOffsetedDate:(NSDate*)offsetDate expectedDateStr:(NSString*)expectedDateStr
{
	STAssertNotNil(offsetDate, @"checkNextDate: Expecting a date %@, got nil", expectedDateStr);
	NSString *offsetDateStr = [self.dateHelper stringFromDate:offsetDate];
	
	STAssertEqualObjects(expectedDateStr,offsetDateStr,@"checkOffsetedDate: Expecting date %@, got %@",
				expectedDateStr,offsetDateStr);
	NSLog(@"checkNextDate: Expecting date %@, got %@",expectedDateStr,offsetDateStr);
}

- (void)testSameYearDifferentDay
{
	NSDate *baseDate = [self.dateHelper dateFromStr:@"2011-01-01"];

	[self checkOffsetedDate:[self.dateHelper 
		sameYearDifferentDay:baseDate andMonth:12 andDay:31] expectedDateStr:@"2011-12-31"];
	[self checkOffsetedDate:[self.dateHelper 
		sameYearDifferentDay:baseDate andMonth:4 andDay:15] expectedDateStr:@"2011-04-15"];
	[self checkOffsetedDate:[self.dateHelper 
		sameYearDifferentDay:baseDate andMonth:9 andDay:15] expectedDateStr:@"2011-09-15"];
	[self checkOffsetedDate:[self.dateHelper 
		sameYearDifferentDay:baseDate andMonth:1 andDay:1] expectedDateStr:@"2011-01-01"];
	
	
}

- (void)testOffsetDates {
    
	NSDate *baseDate = [self.dateHelper dateFromStr:@"2011-01-01"];
	[self checkOffsetedDate:[self.dateHelper beginningOfYear:baseDate]		expectedDateStr:@"2011-01-01"];
	[self checkOffsetedDate:[self.dateHelper beginningOfNextYear:baseDate]	expectedDateStr:@"2012-01-01"];
	[self checkOffsetedDate:[self.dateHelper endOfYear:baseDate]				expectedDateStr:@"2011-12-31"];

	baseDate = [self.dateHelper dateFromStr:@"2011-12-31"];
	[self checkOffsetedDate:[self.dateHelper beginningOfYear:baseDate]		expectedDateStr:@"2011-01-01"];
	[self checkOffsetedDate:[self.dateHelper beginningOfNextYear:baseDate]	expectedDateStr:@"2012-01-01"];
	[self checkOffsetedDate:[self.dateHelper endOfYear:baseDate]				expectedDateStr:@"2011-12-31"];


	baseDate = [self.dateHelper dateFromStr:@"2011-8-31"];
	[self checkOffsetedDate:[self.dateHelper beginningOfYear:baseDate]		expectedDateStr:@"2011-01-01"];
	[self checkOffsetedDate:[self.dateHelper beginningOfNextYear:baseDate]	expectedDateStr:@"2012-01-01"];
	[self checkOffsetedDate:[self.dateHelper endOfYear:baseDate]				expectedDateStr:@"2011-12-31"];


}

- (void)checkOneYearNum:(NSInteger)expectedYear andDate:(NSString*)dateStr
{
	NSDate *dateWithinYear = [self.dateHelper dateFromStr:dateStr];
	NSInteger yearNum = [self.dateHelper yearOfDate:dateWithinYear];
	STAssertEquals(yearNum,expectedYear,@"Expecting year num = %d, got %d",expectedYear,yearNum);
	NSLog(@"Expecting year num = %d, got %d",expectedYear,yearNum);
}

- (void)testYearNum
{
	[self checkOneYearNum:2008 andDate:@"2008-01-01"];
	[self checkOneYearNum:2008 andDate:@"2008-04-15"];
	[self checkOneYearNum:2008 andDate:@"2008-10-01"];
	[self checkOneYearNum:2008 andDate:@"2008-12-31"];
	
	[self checkOneYearNum:2010 andDate:@"2010-01-01"];
	[self checkOneYearNum:2010 andDate:@"2010-05-12"];
}

@end
