//
//  MilestoneDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MilestoneDate.h"
#import "SimDateVisitor.h"


NSString * const MILESTONE_DATE_ENTITY_NAME = @"MilestoneDate";

@implementation MilestoneDate
@dynamic name;

- (NSString *)inlineDescription:(NSDateFormatter*)withFormat
{
	return [NSString stringWithFormat:@"%@ (%@)",
			[withFormat stringFromDate:self.date], self.name];
}

- (NSString *)dateLabel
{
	return self.name;
}

-(void)acceptVisitor:(id<SimDateVisitor>)visitor
{
	[visitor visitMilestoneDate:self];
}

@end
