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



@interface SimEngine : NSObject {

    
    
    @private
    
    // TBD - Should these private member variable names have a "_" suffice 
    // (or whatever is conventional for objective C)
    
    SimEventList *eventList;
	
    FiscalYearDigest *digest;
    NSMutableArray *eventCreators;
	
	SimParams *simParams;

    
}

- (void)runSim;

@property (nonatomic, retain) NSMutableArray *eventCreators;
@property(nonatomic,retain) FiscalYearDigest *digest;
@property(nonatomic,retain) SimEventList *eventList;
@property(nonatomic,retain) SimParams *simParams;



@end
