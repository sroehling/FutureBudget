//
//  MilestoneDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MilestoneDate.h"


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

@end
