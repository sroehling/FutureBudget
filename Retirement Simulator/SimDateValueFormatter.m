//
//  SimDateValueFormatter.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimDateValueFormatter.h"
#import "DateHelper.h"
#import "MilestoneDate.h"
#import "FixedDate.h"
#import "NeverEndDate.h"
#import "LocalizationHelper.h"


@implementation SimDateValueFormatter

@synthesize formattedVal;

- (NSString*)formatSimDate:(SimDate*)theSimDate
{
	[theSimDate acceptVisitor:self];
	assert(self.formattedVal != nil);
	return self.formattedVal;
}

- (void)visitMilestoneDate:(MilestoneDate*)milestoneDate
{
	self.formattedVal = 
		[[[DateHelper theHelper] mediumDateFormatter] stringFromDate:milestoneDate.date];
}

- (void)visitNeverEndDate:(NeverEndDate*)neverEndDate
{
	self.formattedVal = LOCALIZED_STR(@"SIM_DATE_NEVER_ENDING_DATE_LABEL");
}

- (void)visitFixedDate:(FixedDate*)fixedDate;
{
	self.formattedVal = 
		[[[DateHelper theHelper] mediumDateFormatter] stringFromDate:fixedDate.date];

}

- (void) dealloc
{
	[super dealloc];
	[formattedVal release];
}


@end
