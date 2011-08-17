//
//  RelativeEndDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RelativeEndDate.h"
#import "DataModelController.h"
#import "LocalizationHelper.h"
#import "DateHelper.h"
#import "RelativeEndDateInfo.h"


NSString * const RELATIVE_END_DATE_ENTITY_NAME = @"RelativeEndDate";

@implementation RelativeEndDate

@dynamic years;
@dynamic months;
@dynamic weeks;


- (NSString *)yearLabel
{
	if([self.years intValue]> 1)
	{
		return LOCALIZED_STR(@"RELATIVE_END_DATE_DESCRIPTION_MULTIPLE_YEAR_LABEL");
	}
	else
	{
		return LOCALIZED_STR(@"RELATIVE_END_DATE_DESCRIPTION_SINGLE_YEAR_LABEL");
	}
}


- (NSString *)monthLabel
{
	if([self.months intValue]> 1)
	{
		return LOCALIZED_STR(@"RELATIVE_END_DATE_DESCRIPTION_MULTIPLE_MONTH_LABEL");
	}
	else
	{
		return LOCALIZED_STR(@"RELATIVE_END_DATE_DESCRIPTION_SINGLE_MONTH_LABEL");
	}
}

- (NSString *)weekLabel
{
	if([self.weeks intValue]> 1)
	{
		return LOCALIZED_STR(@"RELATIVE_END_DATE_DESCRIPTION_MULTIPLE_WEEK_LABEL");
	}
	else
	{
		return LOCALIZED_STR(@"RELATIVE_END_DATE_DESCRIPTION_SINGLE_WEEK_LABEL");
	}
}


- (RelativeEndDateInfo*)relEndDateInfo
{
	RelativeEndDateInfo *theRelEndDateInfo = [[[RelativeEndDateInfo alloc] init] autorelease];
	theRelEndDateInfo.years = [self.years intValue];
	theRelEndDateInfo.months = [self.months intValue];
	theRelEndDateInfo.weeks = [self.weeks intValue];
	assert(theRelEndDateInfo.years >= 0);
	assert(theRelEndDateInfo.months >= 0);
	assert(theRelEndDateInfo.weeks >=0);
	
	return theRelEndDateInfo;
}

- (void)setWithRelEndDateInfo:(RelativeEndDateInfo*)theRelEndDateInfo
{
	assert(theRelEndDateInfo != nil);
	assert(theRelEndDateInfo.years >= 0);
	assert(theRelEndDateInfo.months >= 0);
	assert(theRelEndDateInfo.weeks >=0);

	self.years = [NSNumber numberWithInt:theRelEndDateInfo.years];
	self.months = [NSNumber numberWithInt:theRelEndDateInfo.months];
	self.weeks = [NSNumber numberWithInt:theRelEndDateInfo.weeks];

}

- (NSString *)relativeDateDescription
{
	NSString *yearsFormat;
	bool previousVals = false;
	if([self.years intValue] > 0)
	{			
		yearsFormat = [NSString stringWithFormat:@"%d %@",
			[self.years intValue],[self yearLabel]];
		previousVals = TRUE;
	}
	else
	{
		yearsFormat = @"";
	}
	NSString *monthsFormat;
	NSString *sep = (previousVals?@", ":@"");
	if([self.months intValue] > 0)
	{
		monthsFormat = [NSString stringWithFormat:@"%@%d %@",
			sep,[self.months intValue],[self monthLabel]];
		previousVals = TRUE;
	}
	else
	{
		monthsFormat = @"";
	}
	NSString *weeksFormat;
	sep = (previousVals?@", ":@"");
	if([self.weeks intValue] > 0)
	{
		weeksFormat = [NSString stringWithFormat:@"%@%d %@",
			sep,[self.weeks intValue],[self weekLabel]];
	}
	else
	{
		weeksFormat = @"";
	}
	
	
    NSString *descriptionStr = [NSString stringWithFormat:@"%@%@%@",
		yearsFormat,monthsFormat,weeksFormat];
    
   return descriptionStr;

}


- (NSString *)inlineDescription:(NSDateFormatter*)withFormat
{
	return [self relativeDateDescription];
}

- (NSString *)dateLabel
{
	return @""; // no label
}


- (void)acceptVisitor:(id<SimDateVisitor>)visitor
{
	[visitor visitRelativeEndDate:self];
}


- (NSDate*)endDateWithStartDate:(NSDate*)startDate
{
    NSDateComponents *repeatOffsetComponents = [[[NSDateComponents alloc] init] autorelease];
	[repeatOffsetComponents setYear:[self.years intValue]];
	[repeatOffsetComponents setMonth:[self.months intValue]];
	[repeatOffsetComponents setWeek:[self.weeks intValue]];
	NSDate *endDate = [[DateHelper theHelper].gregorian dateByAddingComponents:repeatOffsetComponents 
                 toDate:startDate options:0];
	return endDate;

}



@end
