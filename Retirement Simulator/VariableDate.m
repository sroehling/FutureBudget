//
//  VariableDate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableDate.h"


@implementation VariableDate

@dynamic date;

- (NSString *)inlineDescription:(NSDateFormatter*)withFormat
{
	assert(0); // must be overridden
	return nil;
}

- (NSString *)dateLabel
{
	assert(0); // must be overridden
	return nil;

}

@end
