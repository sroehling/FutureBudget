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
#import "TaxInputCalcs.h"
#import "SharedAppValues.h"
#import "ProgressUpdateDelegate.h"

@implementation SimResultsController

@synthesize endOfYearResults;
@synthesize resultMaxYear;
@synthesize resultMinYear;
@synthesize assetsSimulated;
@synthesize loansSimulated;
@synthesize acctsSimulated;
@synthesize incomesSimulated;
@synthesize expensesSimulated;

@synthesize scenarioSimulated;

@synthesize dataModelController;
@synthesize sharedAppVals;
@synthesize taxesSimulated;

@synthesize resultsOutOfDate;
@synthesize excludePartialYearResults;

static SimResultsController *theSimResultsControllerSingleton; 

-(void)trimResultsForPartialYears
{
	if(self.excludePartialYearResults)
	{
		EndOfYearDigestResult *eoyResult; 
		if([self.endOfYearResults count] > 0)
		{
			eoyResult = (EndOfYearDigestResult *)[self.endOfYearResults objectAtIndex:0];
			if(!eoyResult.fullYearSimulated)
			{
				[self.endOfYearResults removeObjectAtIndex:0];
			}
		}
		if([self.endOfYearResults count] > 0)
		{
			NSInteger lastIndex = [self.endOfYearResults count] - 1;
			eoyResult = (EndOfYearDigestResult *)[self.endOfYearResults objectAtIndex:lastIndex];
			if(!eoyResult.fullYearSimulated)
			{
				[self.endOfYearResults removeObjectAtIndex:lastIndex];
			}
		}
	}
}

- (void) runSimulatorForResults:(id<ProgressUpdateDelegate>)simProgressDelegate
{
     
    NSLog(@"Starting simulation run...");
    
    SimEngine *simEngine = [[SimEngine alloc] 
		initWithDataModelController:self.dataModelController 
		andSharedAppValues:self.sharedAppVals ];
           
    [simEngine runSim:simProgressDelegate];
	
	self.scenarioSimulated = simEngine.simParams.simScenario;
	
	self.endOfYearResults = simEngine.digest.savedEndOfYearResults;
	
	[self trimResultsForPartialYears];
	
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
	self.taxesSimulated = [simEngine.simParams.taxInputCalcs taxesSimulated];
    
     NSLog(@"... Done running simulation");
    
    [simEngine release];
	resultsOutOfDate = FALSE;
	
}

- (void)runSimulatorForResults
{
	[self runSimulatorForResults:self];
}

-(void)updateProgress:(CGFloat)currentProgress
{
	// no-op
}

- (void)managedObjectsChanged
{
    NSLog(@"SimResultsController - Managed Objects Changed - marking results out of date");
	resultsOutOfDate = TRUE;
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
		
		// By default, results from partial years (in particular, the first year),
		// will not be excluded.
		self.excludePartialYearResults = FALSE;
		
		// TODO - Need to observe changes to any data model controller.
		[self.dataModelController startObservingAnyContextChanges:self 
			withSelector:@selector(managedObjectsChanged)];
		resultsOutOfDate = TRUE;

	}
	return self;

}

-(id)init
{
	assert(0);
	return nil;
}

+(void)initSingleton:(SimResultsController*)theSimResultsCtrl
{
	assert(theSimResultsCtrl != nil);
	assert(theSimResultsControllerSingleton == nil);
	[theSimResultsCtrl retain];
	theSimResultsControllerSingleton = theSimResultsCtrl;
}

+(SimResultsController*)theSimResultsController
{
	assert(theSimResultsControllerSingleton != nil);
	return theSimResultsControllerSingleton;
}

+(void)initSingletonFromDataModelController:(DataModelController*)dataModelController
{
	SimResultsController *theResultsController = [[[SimResultsController alloc] 
		initWithDataModelController:dataModelController 
		andSharedAppValues:[SharedAppValues getUsingDataModelController:dataModelController]] autorelease];
	theResultsController.excludePartialYearResults = FALSE;
	[SimResultsController initSingleton:theResultsController];	
}


-(void)dealloc
{
	[self.dataModelController stopObservingAnyContextChanges:self];
	
	[endOfYearResults release];
	[assetsSimulated release];
	[loansSimulated release];
	[acctsSimulated release];
	[incomesSimulated release];
	[expensesSimulated release];
	[taxesSimulated release];
	
	[scenarioSimulated release];
	
	[dataModelController release];
	[sharedAppVals release];
	[super dealloc];
}


@end
