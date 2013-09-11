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

@synthesize simResultsCalcDmc;
@synthesize mainDmc;

@synthesize resultsOutOfDate;
@synthesize currentSimResults;
@synthesize simResultsGenQueue;

static SimResultsController *theSimResultsControllerSingleton;


-(void)dealloc
{
	[self.mainDmc stopObservingAnyContextChanges:self];
    
	[simResultsCalcDmc release];
    [mainDmc release];
    
    [currentSimResults release];
    
    [simResultsGenQueue release];
    
	[super dealloc];
}



- (void) runSimulatorForResults:(id<ProgressUpdateDelegate>)simProgressDelegate
{
     
    NSLog(@"Starting simulation run...");
    
    SimEngine *simEngine = [[SimEngine alloc] 
		initWithDataModelController:self.simResultsCalcDmc 
		andSharedAppValues:[SharedAppValues getUsingDataModelController:self.simResultsCalcDmc] ];
           
    [simEngine runSim:simProgressDelegate];
    
    self.currentSimResults = [[[SimResults alloc] initWithSimEngine:simEngine] autorelease];
    
     NSLog(@"... Done running simulation");
        
    [simEngine release];
	resultsOutOfDate = FALSE;
	
}

-(void)updateProgress:(CGFloat)currentProgress
{
	// no-op
}

- (void)managedObjectsChanged
{
    // TODO - Launch a thread to calculate results, stopping the other thread first.

    
    NSLog(@"SimResultsController - Managed Objects Changed - marking results out of date");
	resultsOutOfDate = TRUE;
    self.currentSimResults = nil;
}


-(id)initWithDataModelController:(DataModelController*)mainDataModelController
{
	self = [super init];
	if(self)
	{
        self.mainDmc = mainDataModelController;
        
        // TODO - simResultsCalcDmc needs to have its NSManagedObjectContext be a child of the
        // self.mainDmc's NSManagedObjectContext, ensuring any unsaved changes in self.mainDmc
        // are seen in the object's fetched from self.simResultsCalcDmc
        self.simResultsCalcDmc = [[[DataModelController alloc]
               initWithPersistentStoreCoord:mainDataModelController.persistentStoreCoordinator] autorelease];
        self.simResultsCalcDmc.saveEnabled = FALSE;
				
		[self.mainDmc startObservingAnyContextChanges:self 
			withSelector:@selector(managedObjectsChanged)];
		resultsOutOfDate = TRUE;
        
        self.simResultsGenQueue = [[[NSOperationQueue alloc] init] autorelease];

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

+(void)initSingletonFromMainDataModelController:(DataModelController*)mainDataModelController
{
	SimResultsController *theResultsController = [[[SimResultsController alloc] 
		initWithDataModelController:mainDataModelController] autorelease];
	[SimResultsController initSingleton:theResultsController];	
}




@end
