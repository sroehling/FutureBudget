//
//  VariableRate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableRate.h"


@implementation VariableRate

@synthesize dailyRate;
@synthesize daysSinceStart;

- (id) initWithDailyRate:(double)theRate andDaysSinceStart:(unsigned int)theDaysSinceStart
{
	self = [super init];
	if(self)
	{
		self.daysSinceStart = theDaysSinceStart;
		self.dailyRate = theRate;
	}
	return self;
}

- (id) initWithAnnualRate:(double)theAnnualRate andDaysSinceStart:(unsigned int)theDaysSinceStart
{
	self = [super init];
	if(self)
	{
		self.daysSinceStart = theDaysSinceStart;
		self.dailyRate = pow(theAnnualRate + 1.0,1.0/365.0) - 1.0;
	}
	return self;
	
}

- (id) init 
{
	assert(0); // must call init above
	return nil;
}

@end
