//
//  SimParams.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimParams.h"
#import "Scenario.h"
#import "InputSimInfoCltn.h"
#import "InputValDigestSummations.h"
#import "TaxInputCalcs.h"
#import "SimDate.h"
#import "SharedAppValues.h"
#import "WorkingBalanceMgr.h"
#import "DateHelper.h"

@implementation SimParams

@synthesize simStartDate;
@synthesize digestStartDate;
@synthesize simEndDate;

@synthesize simScenario;

@synthesize incomeInfo;
@synthesize expenseInfo;

@synthesize digestSums;
@synthesize workingBalanceMgr;

@synthesize taxInputCalcs;

- (id)initWithStartDate:(NSDate*)startDate andScenario:(Scenario*)scenario
{
	self = [super init];
	if(self)
	{
		assert(startDate != nil);
		self.simStartDate = startDate;
		self.digestStartDate = [DateHelper beginningOfYear:startDate];
		self.simEndDate = [[SharedAppValues singleton].simEndDate endDateWithStartDate:self.simStartDate];
		
		assert(scenario != nil);
		self.simScenario = scenario;
		
		self.incomeInfo = [[[InputSimInfoCltn alloc] init] autorelease];
		self.expenseInfo = [[[InputSimInfoCltn alloc] init] autorelease];
		self.digestSums = [[[InputValDigestSummations alloc] init] autorelease];
		
		self.taxInputCalcs = [[[TaxInputCalcs alloc] init] autorelease];
			
		self.workingBalanceMgr = [[[WorkingBalanceMgr alloc] initWithStartDate:self.digestStartDate] autorelease];

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
	[digestStartDate release];
	[simEndDate release];
	
	[simScenario release];
	
	[incomeInfo release];
	[expenseInfo release];
	
	[digestSums release];
	
	[taxInputCalcs release];
	
	[workingBalanceMgr release];
}

@end
