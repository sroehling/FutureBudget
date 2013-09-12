//
//  SimResultsController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProgressUpdateDelegate.h"

@class DataModelController;
@class SharedAppValues;
@class SimResults;

extern NSString * const SIM_RESULTS_PROGRESS_NOTIFICATION_NAME;
extern NSString * const SIM_RESULTS_NEW_RESULTS_AVAILABLE_NOTIFICATION_NAME;

@interface SimResultsController : NSObject <ProgressUpdateDelegate> {
	@private
        DataModelController *mainDmc;
        SimResults *currentSimResults;
        NSOperationQueue *simResultsGenQueue;
}

@property(nonatomic,retain) DataModelController *mainDmc;
@property(nonatomic,retain) SimResults *currentSimResults;
@property(nonatomic,retain) NSOperationQueue *simResultsGenQueue;

+(void)initSingletonFromMainDataModelController:(DataModelController*)mainDataModelController;
+(SimResultsController*)theSimResultsController;
+(CGFloat)progressValFromSimProgressUpdate:(NSNotification*)simProgressNotification;

@end
