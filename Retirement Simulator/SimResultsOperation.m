//
//  SimResultsOperation.m
//  FutureBudget
//
//  Created by Steve Roehling on 9/10/13.
//
//

#import "SimResultsOperation.h"
#import "DataModelController.h"
#import "SharedAppValues.h"
#import "SimEngine.h"
#import "SimResults.h"


@implementation SimResultsOperation

@synthesize mainDmc;
@synthesize resultsDelegate;
@synthesize simResults;

-(void)dealloc
{
    [mainDmc release];
    [simResults release];
    [super dealloc];
}

-(id)initWithDataModelController:(DataModelController*)theMainDataModelController
              andResultsDelegate:(id<SimExecutionResultsDelegate>)theResultsDelegate
{
    self = [super init];
    if(self)
    {
        assert(theMainDataModelController != nil);
        self.mainDmc = theMainDataModelController;
        
        assert(theResultsDelegate != nil);
        self.resultsDelegate = theResultsDelegate;
    }
    return self;
}

-(void)sendProgressUpdateToMainThread
{
    [self.resultsDelegate updateSimProgress:currentSimProgress];
}

-(void)updateProgress:(CGFloat)currentProgress
{
    assert(currentProgress >= 0.0);
    assert(currentProgress <= 100.0);
    
    currentSimProgress = currentProgress;
    
    [self performSelectorOnMainThread:@selector(sendProgressUpdateToMainThread)
                           withObject:nil waitUntilDone:TRUE];
}

-(void)sendResultsToDelegate
{
    assert(self.simResults != nil);
    [self.resultsDelegate simResultsGenerated:self.simResults];
}

-(void)main
{
    // TODO - simResultsCalcDmc needs to have its NSManagedObjectContext be a child of the
    // self.mainDmc's NSManagedObjectContext, ensuring any unsaved changes in self.mainDmc
    // are seen in the object's fetched from self.simResultsCalcDmc
    DataModelController *simResultsCalcDmc = [[[DataModelController alloc]
            initWithPersistentStoreCoord:self.mainDmc.persistentStoreCoordinator] autorelease];
 //   simResultsCalcDmc.managedObjectContext.parentContext = self.mainDmc.managedObjectContext;
    simResultsCalcDmc.saveEnabled = FALSE;
    
    
    SimEngine *simEngine = [[SimEngine alloc] initWithDataModelController:simResultsCalcDmc
                andSharedAppValues:[SharedAppValues getUsingDataModelController:simResultsCalcDmc] ];
    simEngine.simExecutionOperation = self;
    
    [simEngine runSim:self];
    
    if(!self.isCancelled)
    {
        self.simResults = [[[SimResults alloc] initWithSimEngine:simEngine] autorelease];
        
        [self performSelectorOnMainThread:@selector(sendResultsToDelegate) withObject:nil waitUntilDone:TRUE];        
    }
    
    [simEngine release];
}


@end
