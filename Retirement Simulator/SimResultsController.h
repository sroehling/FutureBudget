//
//  SimResultsController.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataModelController;
@class SharedAppValues;

@interface SimResultsController : NSObject {
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
		
		DataModelController *dataModelController;
		SharedAppValues *sharedAppVals;
		
		BOOL resultsOutOfDate;
    
}

@property(nonatomic,retain) NSMutableArray *endOfYearResults;
@property NSInteger resultMinYear;
@property NSInteger resultMaxYear;

@property(nonatomic,retain) NSSet *assetsSimulated;
@property(nonatomic,retain) NSSet *loansSimulated;
@property(nonatomic,retain) NSSet *acctsSimulated;
@property(nonatomic,retain) NSSet *incomesSimulated;
@property(nonatomic,retain) NSSet *expensesSimulated;
@property(nonatomic,retain) NSSet *taxesSimulated;

@property(nonatomic,retain) DataModelController *dataModelController;
@property(nonatomic,retain) SharedAppValues *sharedAppVals;

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andSharedAppValues:(SharedAppValues *)theSharedAppVals;

+(void)initFromDatabase;
+(SimResultsController*)theSimResultsController;

- (void) runSimulatorForResults;
- (void) runSimulatorIfResultsOutOfDate;

@end
