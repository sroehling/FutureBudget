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
#import "DataModelController.h"
#import "SharedAppValues.h"

@implementation SimResultsController

@synthesize endOfYearResults;
@synthesize resultMaxYear;
@synthesize resultMinYear;
@synthesize assetsSimulated;
@synthesize loansSimulated;
@synthesize acctsSimulated;
@synthesize incomesSimulated;
@synthesize expensesSimulated;

@synthesize dataModelController;
@synthesize sharedAppVals;

- (void) runSimulatorForResults
{
     
    NSLog(@"Starting simulation run...");
    
    SimEngine *simEngine = [[SimEngine alloc] initWithDataModelController:self.dataModelController andSharedAppValues:self.sharedAppVals ];
           
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
	self.loansSimulated = simEngine.simParams.loanInfo.inputsSimulated;
	self.acctsSimulated = simEngine.simParams.acctInfo.inputsSimulated;
	self.incomesSimulated = simEngine.simParams.incomeInfo.inputsSimulated;
	self.expensesSimulated = simEngine.simParams.expenseInfo.inputsSimulated;
    

    
     NSLog(@"... Done running simulation");
    
    [simEngine release];
}

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andSharedAppValues:(SharedAppValues *)theSharedAppVals
{
	self = [super init];
	if(self)
	{
		// Default to run the simulation on the data in database file.
		self.dataModelController = theDataModelController;
		self.sharedAppVals = theSharedAppVals;
	}
	return self;

}

-(id)init
{
	return [self initWithDataModelController:[DataModelController theDataModelController] 
			andSharedAppValues:[SharedAppValues singleton]];
}

-(void)dealloc
{
	[super dealloc];
	[endOfYearResults release];
	[assetsSimulated release];
	[loansSimulated release];
	[acctsSimulated release];
	[incomesSimulated release];
	[expensesSimulated release];
	
	[dataModelController release];
	[sharedAppVals release];
}


@end
