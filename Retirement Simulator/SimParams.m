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
#import "Cash.h"
#import "FixedValue.h"
#import "InflationRate.h"
#import "DateHelper.h"

@implementation SimParams

@synthesize simStartDate;
@synthesize digestStartDate;
@synthesize simEndDate;

@synthesize simScenario;

@synthesize incomeInfo;
@synthesize expenseInfo;
@synthesize acctInfo;
@synthesize assetInfo;
@synthesize loanInfo;

@synthesize digestSums;
@synthesize workingBalanceMgr;
@synthesize inflationRate;

@synthesize taxInputCalcs;

-(id)initWithStartDate:(NSDate*)simStart andDigestStartDate:(NSDate*)digestStart
	andSimEndDate:(NSDate*)simEnd andScenario:(Scenario*)scen andCashBal:(double)cashBal
	andDeficitRate:(FixedValue*)deficitRate andInflationRate:(InflationRate*)theInflationRate
{
	self = [super init];
	if(self)
	{
		self.simStartDate = simStart;
		self.digestStartDate = digestStart;
		self.simEndDate = simEnd;
		
		self.simScenario = scen;
		
		self.incomeInfo = [[[InputSimInfoCltn alloc] init] autorelease];
		self.expenseInfo = [[[InputSimInfoCltn alloc] init] autorelease];
		self.acctInfo = [[[InputSimInfoCltn alloc] init] autorelease];
		self.assetInfo = [[[InputSimInfoCltn alloc] init] autorelease];
		self.loanInfo = [[[InputSimInfoCltn alloc] init] autorelease];
		
		
		self.digestSums = [[[InputValDigestSummations alloc] init] autorelease];
		
		self.taxInputCalcs = [[[TaxInputCalcs alloc] init] autorelease];
		
		assert(theInflationRate != nil);
		self.inflationRate = theInflationRate;
			
		self.workingBalanceMgr = [[[WorkingBalanceMgr alloc] initWithStartDate:self.digestStartDate
			andCashBal:cashBal andDeficitInterestRate:deficitRate] autorelease];

	}
	return self;
}

-(id)initWithSharedAppVals:(SharedAppValues*)sharedAppVals
{
	NSDate *simStart = [sharedAppVals beginningOfSimStartDate];
	
	// Since the granularity of simulation results is 1 year, we round the end date to the 
	// beginning of the next year, ensuring that the last year is complete.
	NSDate *unroundedSimEnd = [sharedAppVals.simEndDate endDateWithStartDate:simStart];
	NSDate *simEnd = [DateHelper beginningOfNextYear:unroundedSimEnd];
	
	NSDate *digestStart = [DateHelper beginningOfYear:simStart];
	Scenario *simScen = sharedAppVals.currentInputScenario;
	double cashBal = [sharedAppVals.cash.startingBalance doubleValue];
	FixedValue *deficitRate = sharedAppVals.deficitInterestRate;
	
	return [self initWithStartDate:simStart andDigestStartDate:digestStart 
		andSimEndDate:simEnd andScenario:simScen andCashBal:cashBal andDeficitRate:deficitRate
		andInflationRate:sharedAppVals.defaultInflationRate];

}


- (id) init
{
	assert(0); // must init with start data and scenario
	return nil;
}

- (void)dealloc
{

	[simStartDate release];
	[digestStartDate release];
	[simEndDate release];
	
	[simScenario release];
	
	[incomeInfo release];
	[expenseInfo release];
	[acctInfo release];
	[assetInfo release];
	[loanInfo release];
	
	[digestSums release];
	
	[taxInputCalcs release];
	
	[workingBalanceMgr release];
	[inflationRate release];
	[super dealloc];
}

@end
