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
@class Scenario;

@interface SimResultsController : NSObject <ProgressUpdateDelegate> {
	@private
		NSMutableArray *endOfYearResults;
		NSInteger resultMinYear;
		NSInteger resultMaxYear;
		
		NSSet *assetsSimulated;
		NSSet *loansSimulated;
		NSSet *acctsSimulated;
		NSSet *incomesSimulated;
		NSSet *expensesSimulated;
		NSSet *taxesSimulated;
		
		Scenario *scenarioSimulated;
		
		DataModelController *dataModelController;
		SharedAppValues *sharedAppVals;
		
		BOOL resultsOutOfDate;
		
		// Optional - exclude results from years where only 
		// part of the year is simulated.
		BOOL excludePartialYearResults;
    
}

@property(nonatomic,retain) NSMutableArray *endOfYearResults;
@property NSInteger resultMinYear;
@property NSInteger resultMaxYear;
@property BOOL excludePartialYearResults;

@property(nonatomic,retain) NSSet *assetsSimulated;
@property(nonatomic,retain) NSSet *loansSimulated;
@property(nonatomic,retain) NSSet *acctsSimulated;
@property(nonatomic,retain) NSSet *incomesSimulated;
@property(nonatomic,retain) NSSet *expensesSimulated;
@property(nonatomic,retain) NSSet *taxesSimulated;

@property(nonatomic,retain) Scenario *scenarioSimulated;

@property(nonatomic,retain) DataModelController *dataModelController;
@property(nonatomic,retain) SharedAppValues *sharedAppVals;
@property(readonly) BOOL resultsOutOfDate;

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andSharedAppValues:(SharedAppValues *)theSharedAppVals;
+(void)initSingletonFromDataModelController:(DataModelController*)dataModelController;
+(SimResultsController*)theSimResultsController;

- (void) runSimulatorForResults:(id<ProgressUpdateDelegate>)simProgressDelegate;
- (void)runSimulatorForResults;

@end
