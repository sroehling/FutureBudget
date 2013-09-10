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
#import "DataModelController.h"
#import "TaxInputCalcs.h"
#import "SharedAppValues.h"
#import "ProgressUpdateDelegate.h"
#import "SimResults.h"

@implementation SimResultsController

@synthesize dataModelController;
@synthesize sharedAppVals;

@synthesize resultsOutOfDate;
@synthesize currentSimResults;

static SimResultsController *theSimResultsControllerSingleton;


-(void)dealloc
{
	[self.dataModelController stopObservingAnyContextChanges:self];
    
	[dataModelController release];
	[sharedAppVals release];
    [currentSimResults release];
    
	[super dealloc];
}



- (void) runSimulatorForResults:(id<ProgressUpdateDelegate>)simProgressDelegate
{
     
    NSLog(@"Starting simulation run...");
    
    SimEngine *simEngine = [[SimEngine alloc] 
		initWithDataModelController:self.dataModelController 
		andSharedAppValues:self.sharedAppVals ];
           
    [simEngine runSim:simProgressDelegate];
    
    self.currentSimResults = [[[SimResults alloc] initWithSimEngine:simEngine] autorelease];
    
     NSLog(@"... Done running simulation");
    
    // TODO - Allocate SimResults
    
    [simEngine release];
	resultsOutOfDate = FALSE;
	
}

-(void)updateProgress:(CGFloat)currentProgress
{
	// no-op
}

- (void)managedObjectsChanged
{
    NSLog(@"SimResultsController - Managed Objects Changed - marking results out of date");
	resultsOutOfDate = TRUE;
    self.currentSimResults = nil;
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
	if(theSimResultsControllerSingleton != nil)
	{
		[theSimResultsControllerSingleton release];
	}
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
	[SimResultsController initSingleton:theResultsController];	
}




@end
