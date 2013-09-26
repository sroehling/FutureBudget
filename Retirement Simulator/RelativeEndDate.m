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
    
    NSInteger monthsOffset = [self.monthsOffset integerValue];
    if(monthsOffset <= 0)
    {
        return startDate;
    }
    
    // Start by advancing the full number of months.
    NSDateComponents *repeatOffsetComponents = [[[NSDateComponents alloc] init] autorelease];
	[repeatOffsetComponents setMonth:[self.monthsOffset intValue]];
    DateHelper *dateHelper = [[[DateHelper alloc] init] autorelease];
	NSDate *endDate = [dateHelper.gregorian dateByAddingComponents:repeatOffsetComponents
                          toDate:startDate options:0];
    
    // However, the stop date is 1 day before the full number of months. This
    // results in the range covered by the relative end date to be [startDate, endDate).
    // Otherwise, there is an "off by one bug" where the range includes the first day
    // after adding the range of dates.
    [repeatOffsetComponents setMonth:0];
    [repeatOffsetComponents setDay:-1];
    
    NSDate *adjustedEndDate = [dateHelper.gregorian dateByAddingComponents:repeatOffsetComponents
                                 toDate:endDate options:0];
        
	return adjustedEndDate;

}



@end
