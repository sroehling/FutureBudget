//
//  SimEngine.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FiscalYearDigest;
@class WorkingBalanceMgr;
@class SimEventList;
@class SimParams;
@class DataModelController;
@class SharedAppValues;

@protocol ProgressUpdateDelegate;


@interface SimEngine : NSObject {

    
    
    @private
    
    // TBD - Should these private member variable names have a "_" suffice 
    // (or whatever is conventional for objective C)
    
    SimEventList *eventList;
	
    FiscalYearDigest *digest;
    NSMutableArray *eventCreators;
	
	DataModelController *dataModelController;
	SharedAppValues *sharedAppVals;
	
	SimParams *simParams;
    
    // Optional - Operation under which the simulatino is executing.
    // The simulator will inspect this operation from time to time to
    // see if the operation has been canceled.
    NSOperation *simExecutionOperation;  

    
}

- (id)initWithDataModelController:(DataModelController*)theDataModelController
	andSharedAppValues:(SharedAppValues*)theSharedAppVals;
	
- (void)runSim:(id<ProgressUpdateDelegate>)simProgressDelegate;

@property (nonatomic, retain) NSMutableArray *eventCreators;
@property(nonatomic,retain) FiscalYearDigest *digest;
@property(nonatomic,retain) SimEventList *eventList;
@property(nonatomic,retain) SimParams *simParams;
@property(nonatomic,retain) DataModelController *dataModelController;
@property(nonatomic,retain) SharedAppValues *sharedAppVals;

@property(nonatomic,assign) NSOperation *simExecutionOperation;



@end
