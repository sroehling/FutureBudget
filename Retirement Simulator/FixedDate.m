//
//  FixedDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FixedDate.h"


@implementation FixedDate


- (NSString *)inlineDescription:(NSDateFormatter*)withFormat
{
	return [withFormat stringFromDate:self.date];
}

- (NSString *)dateLabel
{
	return @""; // no label
}

@end
