//
//  MilestoneDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MilestoneDate.h"
#import "SimDateVisitor.h"
#import "LocalizationHelper.h"


NSString * const MILESTONE_DATE_ENTITY_NAME = @"MilestoneDate";

@implementation MilestoneDate
@dynamic name;

- (NSString *)inlineDescription:(NSDateFormatter*)withFormat
{
	return [NSString stringWithFormat:@"%@ (%@)",
			[withFormat stringFromDate:self.date], self.name];
}

-(NSString*)endDatePrefix
{
	return LOCALIZED_STR(@"MILESTONE_DATE_END_DATE_PREFIX");
}

-(void)acceptVisitor:(id<SimDateVisitor>)visitor
{
	[visitor visitMilestoneDate:self];
}

-(BOOL)supportsDeletion
{
	// Only allow deletion if there are no scenario input values referring to
	// to this milestone date.
	if([self.scenarioValInputValues count] <= 0)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

@end
