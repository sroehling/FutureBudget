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
#import "RelativeEndDate.h"
#import "SimDateRuntimeInfo.h"


@implementation SimDateValueFormatter

@synthesize formattedVal;
@synthesize simDateRuntimeInfo;

-(id)initWithSimDateRuntimeInfo:(SimDateRuntimeInfo*)sdRuntimeInfo
{
	self = [super init];
	if(self)
	{
		assert(sdRuntimeInfo != nil);
		self.simDateRuntimeInfo = sdRuntimeInfo;
		
	}
	return self;
}

-(id)init
{
	assert(0); // must init with SimDateRuntimeInfo
	return nil;
}

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
	self.formattedVal = self.simDateRuntimeInfo.neverEndDateFieldCaption;
}

- (void)visitRelativeEndDate:(RelativeEndDate *)relEndDate
{
	self.formattedVal =
		[NSString stringWithFormat:LOCALIZED_STR(@"RELATIVE_END_DATE_SIM_DATE_FIELD_TITLE_FORMAT"),
			[relEndDate relativeDateDescription]];
}

- (void)visitFixedDate:(FixedDate*)fixedDate;
{
	self.formattedVal = 
		[[[DateHelper theHelper] mediumDateFormatter] stringFromDate:fixedDate.date];

}

- (void) dealloc
{
	[formattedVal release];
	[simDateRuntimeInfo release];
	[super dealloc];
}


@end
