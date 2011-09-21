//
//  SimParams.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimParams.h"
#import "Scenario.h"


@implementation SimParams

@synthesize simStartDate;
@synthesize simScenario;

- (id)initWithStartDate:(NSDate*)startDate andScenario:(Scenario*)scenario
{
	self = [super init];
	if(self)
	{
		assert(startDate != nil);
		self.simStartDate = startDate;
		
		assert(scenario != nil);
		self.simScenario = scenario;
	}
	return self;
}

- (id) init
{
	assert(0); // must init with start data and scenario
	return nil;
}

- (void)dealloc
{
	[super dealloc];
	[simStartDate release];
	[simScenario release];
}

@end
