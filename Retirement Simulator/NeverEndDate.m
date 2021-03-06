//
//  NeverEndDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NeverEndDate.h"
#import "LocalizationHelper.h"
#import "DateHelper.h"

#import "SimDateVisitor.h"

NSString * const NEVER_END_DATE_ENTITY_NAME = @"NeverEndDate";
NSString * const NEVER_END_PSEUDO_END_DATE = @"2500-12-31";

@implementation NeverEndDate

// TODO - Need more handling for cascading deletes involving this object (and other InputValue descendents). 
// As it is implemented now, deleting a reference to this
// object may result in an orphan.

@dynamic sharedAppValsNeverEndDate;


- (NSString *)inlineDescription:(NSDateFormatter*)withFormat
{
	return LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_INLINE_LABEL");
}

-(NSString*)endDatePrefix
{
	return LOCALIZED_STR(@"NEVER_ENDING_DATE_END_DATE_PREFIX");
}

- (void)acceptVisitor:(id<SimDateVisitor>)visitor
{
	[visitor visitNeverEndDate:self];
}

- (NSDate*)endDateWithStartDate:(NSDate*)startDate
{
    DateHelper *dateHelper = [[[DateHelper alloc] init] autorelease];
    
	return [dateHelper dateFromStr:NEVER_END_PSEUDO_END_DATE];
}

@end
