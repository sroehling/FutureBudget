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
#import "DurationInfo.h"


NSString * const RELATIVE_END_DATE_ENTITY_NAME = @"RelativeEndDate";
NSString * const RELATIVE_END_DATE_MONTHS_OFFSET_KEY = @"monthsOffset";

@implementation RelativeEndDate

@dynamic monthsOffset;


// TODO - Need more handling for cascading deletes involving this object (and other InputValue descendents). 
// As it is implemented now, deleting a reference to this
// object may result in an orphan.

@dynamic sharedAppValuesDefaultRelEndDate;


-(NSString*)relativeDateDescription
{
	DurationInfo *durationInfo = [[[DurationInfo alloc] initWithTotalMonths:self.monthsOffset] autorelease];
	return [durationInfo yearsAndMonthsFormatted];
}

- (NSString *)inlineDescription:(NSDateFormatter*)withFormat
{
	return [self relativeDateDescription];
}

-(NSString*)endDatePrefix
{
	return LOCALIZED_STR(@"RELATIVE_END_DATE_END_DATE_PREFIX");
}

- (void)acceptVisitor:(id<SimDateVisitor>)visitor
{
	[visitor visitRelativeEndDate:self];
}


- (NSDate*)endDateWithStartDate:(NSDate*)startDate
{
    NSDateComponents *repeatOffsetComponents = [[[NSDateComponents alloc] init] autorelease];
	[repeatOffsetComponents setMonth:[self.monthsOffset intValue]];
	NSDate *endDate = [[DateHelper theHelper].gregorian dateByAddingComponents:repeatOffsetComponents 
                 toDate:startDate options:0];
	return endDate;

}



@end
