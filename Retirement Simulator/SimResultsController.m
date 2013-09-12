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

NSString * const SIM_RESULTS_PROGRESS_NOTIFICATION_NAME = @"SIM_RESULTS_PROGRESS_NOTIFICATION";
NSString * const SIM_RESULTS_PROGRESS_VAL_KEY = @"SIM_RESULTS_PROGRESS_VAL";
NSString * const SIM_RESULTS_NEW_RESULTS_AVAILABLE_NOTIFICATION_NAME = @"SIM_RESULTS_NEW_RESULTS_AVAILABLE_NOTIFICATION_NAME";

@implementation SimResultsController

@synthesize mainDmc;

@synthesize currentSimResults;
@synthesize simResultsGenQueue;

static SimResultsController *theSimResultsControllerSingleton;


-(void)dealloc
{
	[self.mainDmc stopObservingAnyContextChanges:self];
    
    [mainDmc release];
    
    [currentSimResults release];
    
    [simResultsGenQueue release];
    
	[super dealloc];
}

// Helper method to retrieve progress value sent by updateProgress
+(CGFloat)progressValFromSimProgressUpdate:(NSNotification*)simProgressNotification
{
    NSDictionary *userInfo = simProgressNotification.userInfo;
    assert(userInfo != nil);
    NSNumber *progressVal = [userInfo objectForKey:SIM_RESULTS_PROGRESS_VAL_KEY];
    assert(progressVal != nil);
    CGFloat progressFloat = [progressVal floatValue];
    assert(progressFloat >= 0.0);
    assert(progressFloat <= 100.0);
    return progressFloat;
}


-(void)updateProgress:(CGFloat)currentProgress
{
    // Progress updates need to be received on the main thread, since these progress
    // updates can results in UI updates.
    assert(currentProgress>=0.0);
    assert(currentProgress <= 100.0);
    dispatch_async(dispatch_get_main_queue(),^{
        NSNumber *progressNum = [NSNumber numberWithFloat:currentProgress];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:progressNum forKey:SIM_RESULTS_PROGRESS_VAL_KEY];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:SIM_RESULTS_PROGRESS_NOTIFICATION_NAME object:nil userInfo:userInfo];
    });
}

-(void)runSimulatorForResultsInBackground
{
    NSLog(@"Starting simulation run...");
    
    // TODO - simResultsCalcDmc needs to have its NSManagedObjectContext be a child of the
    // self.mainDmc's NSManagedObjectContext, ensuring any unsaved changes in self.mainDmc
    // are seen in the object's fetched from self.simResultsCalcDmc
    DataModelController *simResultsCalcDmc = [[[DataModelController alloc]
                initWithPersistentStoreCoord:self.mainDmc.persistentStoreCoordinator] autorelease];
    simResultsCalcDmc.saveEnabled = FALSE;

    
    SimEngine *simEngine = [[SimEngine alloc] initWithDataModelController:simResultsCalcDmc
          andSharedAppValues:[SharedAppValues getUsingDataModelController:simResultsCalcDmc] ];
        
    [simEngine runSim:self];
        
    self.currentSimResults = [[[SimResults alloc] initWithSimEngine:simEngine] autorelease];
        
    NSLog(@"... Done running simulation");
        
    [simEngine release];
    
    [self performSelectorOnMainThread:@selector(sendUpdatedSimResultsNotification)
                           withObject:nil waitUntilDone:FALSE];
}

-(void)sendUpdatedSimResultsNotification
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SIM_RESULTS_NEW_RESULTS_AVAILABLE_NOTIFICATION_NAME object:nil];
}

- (void)managedObjectsChanged
{
    // TODO - Launch a thread to calculate results, stopping the other thread first.
    NSLog(@"SimResultsController - Managed Objects Changed - regenerating results");
    [self performSelectorInBackground:
        @selector(runSimulatorForResultsInBackground) withObject:nil];
}


-(id)initWithDataModelController:(DataModelController*)mainDataModelController
{
	self = [super init];
	if(self)
	{
        self.mainDmc = mainDataModelController;
        
				
		[self.mainDmc startObservingAnyContextChanges:self 
			withSelector:@selector(managedObjectsChanged)];
        
        self.simResultsGenQueue = [[[NSOperationQueue alloc] init] autorelease];
        
        // Invalidate the current results. It doesn't make sense to
        // show any old results, since they'll be from a different plan.
        self.currentSimResults = nil;
        
        // Run the simulator to get an initial set of results
        [self performSelectorInBackground:
            @selector(runSimulatorForResultsInBackground) withObject:nil];

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
