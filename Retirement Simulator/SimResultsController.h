//
//  SimResultsController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProgressUpdateDelegate.h"
#import "SimResultsOperation.h"

@class DataModelController;
@class SharedAppValues;
@class SimResults;

extern NSString * const SIM_RESULTS_PROGRESS_NOTIFICATION_NAME;
extern NSString * const SIM_RESULTS_NEW_RESULTS_AVAILABLE_NOTIFICATION_NAME;

@interface SimResultsController : NSObject <SimExecutionResultsDelegate> {
	@private
        DataModelController *mainDmc;
        SimResults *currentSimResults;
        NSOperationQueue *simResultsGenQueue;
}

@property(nonatomic,retain) DataModelController *mainDmc;
@property(nonatomic,retain) SimResults *currentSimResults;
@property(nonatomic,retain) NSOperationQueue *simResultsGenQueue;

// Call once to to initialize the  budget/plan's DataModelController. This also triggers an initial
// running of the simulation to get an updated set of simulation results.
+(void)initSingletonFromMainDataModelController:(DataModelController*)mainDataModelController;

// Call to update the mainDmc with for a new budget/plan. This also triggers re-running
// of the simulation to get an updated set of simulation results.
+(void)updateSingletonWithMainDataModelController:(DataModelController*)mainDataModelController;

+(SimResultsController*)theSimResultsController;
+(CGFloat)progressValFromSimProgressUpdate:(NSNotification*)simProgressNotification;

@end
