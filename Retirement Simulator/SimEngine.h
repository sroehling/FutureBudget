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


@interface SimEngine : NSObject {

    
    NSMutableArray *eventList;
    
    @private
    
    // TBD - Should these private member variable names have a "_" suffice 
    // (or whatever is conventional for objective C)
    
    NSDateComponents *resultsOffsetComponents;
    
    NSDate *nextResultsCheckpointDate;
	NSDate *simEndDate;
    FiscalYearDigest *digest;
    NSMutableArray *eventCreators;
	
	WorkingBalanceMgr *workingBalanceMgr;
    
}

- (void)runSim;

@property (nonatomic, retain) NSMutableArray *eventCreators;
@property(nonatomic,retain) NSDate *simEndDate;
@property(nonatomic,retain) FiscalYearDigest *digest;
@property(nonatomic,retain) WorkingBalanceMgr *workingBalanceMgr;


@end
