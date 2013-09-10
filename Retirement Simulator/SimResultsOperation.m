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


@implementation SimResultsOperation

@synthesize resultsDmc;
@synthesize mainThreadProgressDelegate;

-(void)dealloc
{
    [resultsDmc release];
    [super dealloc];
}

-(id)initWithDataModelController:(DataModelController*)theResultsDataModelController
             andProgressDelegate:(id<ProgressUpdateDelegate>)theMainThreadProgressDelegate
{
    self = [super init];
    if(self)
    {
        assert(theMainThreadProgressDelegate != nil);
        assert(theResultsDataModelController != nil);
        self.resultsDmc = theResultsDataModelController;
        self.mainThreadProgressDelegate = theMainThreadProgressDelegate;
    }
    return self;
}

-(void)mainThreadProgressUpdate
{
    [self.mainThreadProgressDelegate updateProgress:currentSimProgress];
}

-(void)updateProgress:(CGFloat)currentProgress
{
    currentSimProgress = currentProgress;
    [self performSelectorOnMainThread:@selector(mainThreadProgressUpdate)
                           withObject:self waitUntilDone:FALSE];
}

-(void)main
{
    SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:self.resultsDmc];
    
    SimEngine *simEngine = [[[SimEngine alloc]
                             initWithDataModelController:self.resultsDmc
                             andSharedAppValues:sharedAppVals] autorelease];
    
    [simEngine runSim:self];
    
    
}


@end
