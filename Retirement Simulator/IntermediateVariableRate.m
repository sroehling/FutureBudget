//
//  IntermediateVariableRate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IntermediateVariableRate.h"

NSString * const INTERMEDIATE_VARIABLE_RATE_SECONDS_VS_START_KEY = @"secondsVsStart";

@implementation IntermediateVariableRate

@synthesize annualRate;
@synthesize secondsVsStart;

- (id) initWithAnnualRate:(double)theRate andSecondsVsStart:(NSInteger)seconds
{
	self = [super init];
	if(self)
	{
		self.annualRate = theRate;
		self.secondsVsStart = seconds;
	}
	return self;
}

- (id) init 
{
	assert(0); // must call init with annual rate and seconds vs. start.
}

@end
