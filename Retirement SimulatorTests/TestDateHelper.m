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
	
	STAssertEqualObjects(expectedDateStr,offsetDateStr,@"checkNextDate: Expecting date %@, got %@",
				expectedDateStr,offsetDateStr);
	NSLog(@"checkNextDate: Expecting date %@, got %@",expectedDateStr,offsetDateStr);
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
