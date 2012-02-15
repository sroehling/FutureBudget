//
//  SimDateSubtitleFormatter.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimDateSubtitleFormatter.h"
#import "DateHelper.h"
#import "MilestoneDate.h"
#import "FixedDate.h"
#import "NeverEndDate.h"
#import "LocalizationHelper.h"
#import "RelativeEndDate.h"
#import "SimDateRuntimeInfo.h"

@implementation SimDateSubtitleFormatter

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
	self.formattedVal = milestoneDate.name;
}

- (void)visitNeverEndDate:(NeverEndDate*)neverEndDate
{
	self.formattedVal = self.simDateRuntimeInfo.neverEndDateFieldSubtitle;
}

- (void)visitRelativeEndDate:(RelativeEndDate *)relEndDate
{
	self.formattedVal = @"";
}

- (void)visitFixedDate:(FixedDate*)fixedDate;
{
	self.formattedVal = @"";

}

- (void) dealloc
{
	[formattedVal release];
	[simDateRuntimeInfo release];
	[super dealloc];
}


@end
