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

-(void)updateSimProgress:(CGFloat)currentProgress
{
    NSNumber *progressNum = [NSNumber numberWithFloat:currentProgress];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:progressNum forKey:SIM_RESULTS_PROGRESS_VAL_KEY];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SIM_RESULTS_PROGRESS_NOTIFICATION_NAME object:nil userInfo:userInfo];
}

-(void)simResultsGenerated:(SimResults *)simResults
{
    assert(simResults != nil);
    self.currentSimResults = simResults;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:SIM_RESULTS_NEW_RESULTS_AVAILABLE_NOTIFICATION_NAME object:nil];
}


-(void)runSimulatorForResults
{
    [self.simResultsGenQueue cancelAllOperations]; // Cancel any ongoing simulator runs (if any)
    
    SimResultsOperation *simResultsOperation = [[[SimResultsOperation alloc]
                                                 initWithDataModelController:self.mainDmc andResultsDelegate:self]autorelease];
    [self.simResultsGenQueue addOperation:simResultsOperation];
}

- (void)managedObjectsChanged
{
    // TODO - Launch a thread to calculate results, stopping the other thread first.
    NSLog(@"SimResultsController - Managed Objects Changed - regenerating results");
    
    [self runSimulatorForResults];
}


-(void)updateMainDataModelController:(DataModelController*)mainDataModelController
{
    
    assert(mainDataModelController != nil);
    
    if(self.mainDmc != nil)
    {
        [self.mainDmc stopObservingAnyContextChanges:self];
    }
    
    self.mainDmc = mainDataModelController;

    [self.mainDmc startObservingAnyContextChanges:self
            withSelector:@selector(managedObjectsChanged)];

}

-(id)initWithDataModelController:(DataModelController*)mainDataModelController
{
	self = [super init];
	if(self)
	{     
        [self updateMainDataModelController:mainDataModelController];
        
        self.simResultsGenQueue = [[[NSOperationQueue alloc] init] autorelease];
        self.simResultsGenQueue.maxConcurrentOperationCount = 1;

        // Invalidate the current results. It doesn't make sense to
        // show any old results, since they'll be from a different plan.
        self.currentSimResults = nil;
        
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
	assert(theSimResultsControllerSingleton == nil); // initSingleton should only be called once
	[theSimResultsCtrl retain];
	theSimResultsControllerSingleton = theSimResultsCtrl;
}

+(SimResultsController*)theSimResultsController
{
	assert(theSimResultsControllerSingleton != nil);
	return theSimResultsControllerSingleton;
}

+(void)updateSingletonWithMainDataModelController:(DataModelController*)mainDataModelController
{
    SimResultsController *theResultsController = [SimResultsController theSimResultsController];
    
    [theResultsController updateMainDataModelController:mainDataModelController];
    
    // Run the simulator to get an updated set of results
    [theResultsController runSimulatorForResults];
}

+(void)initSingletonFromMainDataModelController:(DataModelController*)mainDataModelController
{
	SimResultsController *theResultsController = [[[SimResultsController alloc] 
		initWithDataModelController:mainDataModelController] autorelease];
	[SimResultsController initSingleton:theResultsController];
    
    // Run the simulator to get an initial set of results
   [theResultsController runSimulatorForResults];
}




@end
