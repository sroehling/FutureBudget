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
		
		DataModelController *dataModelController;
		SharedAppValues *sharedAppVals;
		
		BOOL resultsOutOfDate;
        SimResults *currentSimResults;
}

@property(nonatomic,retain) DataModelController *dataModelController;
@property(nonatomic,retain) SharedAppValues *sharedAppVals;
@property(readonly) BOOL resultsOutOfDate;
@property(nonatomic,retain) SimResults *currentSimResults;

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andSharedAppValues:(SharedAppValues *)theSharedAppVals;
+(void)initSingletonFromDataModelController:(DataModelController*)dataModelController;
+(SimResultsController*)theSimResultsController;

- (void) runSimulatorForResults:(id<ProgressUpdateDelegate>)simProgressDelegate;

@end
