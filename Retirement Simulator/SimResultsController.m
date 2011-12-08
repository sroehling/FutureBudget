//
//  SimResultsController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimResultsController.h"
#import "SimEngine.h"
#import "EndOfYearDigestResult.h"
#import "FiscalYearDigest.h"
#import "SimParams.h"
#import "InputSimInfoCltn.h"


@implementation SimResultsController

@synthesize endOfYearResults;
@synthesize resultMaxYear;
@synthesize resultMinYear;
@synthesize assetsSimulated;

- (void) runSimulatorForResults
{
     
    NSLog(@"Starting simulation run...");
    
    SimEngine *simEngine = [[SimEngine alloc] init ];
           
    [simEngine runSim];
	
	self.endOfYearResults = simEngine.digest.savedEndOfYearResults;
	
	NSInteger minYear = NSIntegerMax;
	NSInteger maxYear = 0;
	for(EndOfYearDigestResult *eoyResult in self.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		minYear = MIN(minYear, resultYear);
		maxYear = MAX(maxYear, resultYear);
		
	}
	assert(maxYear >= minYear);
	self.resultMaxYear = maxYear;
	self.resultMinYear = minYear;
	
	self.assetsSimulated = simEngine.simParams.assetInfo.inputsSimulated;
    

    
     NSLog(@"... Done running simulation");
    
    [simEngine release];
}

-(void)dealloc
{
	[super dealloc];
	[endOfYearResults release];
	[assetsSimulated release];
}


@end
