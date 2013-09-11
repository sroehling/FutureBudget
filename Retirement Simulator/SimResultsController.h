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

@interface SimResultsController : NSObject <ProgressUpdateDelegate> {
	@private
		
        DataModelController *mainDmc;
        DataModelController *simResultsCalcDmc;
    
		BOOL resultsOutOfDate;
        SimResults *currentSimResults;
    
        NSOperationQueue *simResultsGenQueue;

}

@property(nonatomic,retain) DataModelController *mainDmc;
@property(nonatomic,retain) DataModelController *simResultsCalcDmc;


@property(readonly) BOOL resultsOutOfDate;
@property(nonatomic,retain) SimResults *currentSimResults;
@property(nonatomic,retain) NSOperationQueue *simResultsGenQueue;

+(void)initSingletonFromMainDataModelController:(DataModelController*)mainDataModelController;

+(SimResultsController*)theSimResultsController;

- (void) runSimulatorForResults:(id<ProgressUpdateDelegate>)simProgressDelegate;

@end
