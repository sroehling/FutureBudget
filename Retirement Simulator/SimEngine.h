//
//  SimEngine.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FiscalYearDigest;


@interface SimEngine : NSObject {

    
    NSMutableArray *eventList;
    
    @private
    
    // TBD - Should these private member variable names have a "_" suffice 
    // (or whatever is conventional for objective C)
    
    NSDateFormatter *dateFormatter;
    NSDateComponents *resultsOffsetComponents;
    
    NSDate *nextResultsCheckpointDate;
	NSDate *simEndDate;
    FiscalYearDigest *digest;
    NSMutableArray *eventCreators;
    
}

- (void)runSim;

@property (nonatomic, retain) NSMutableArray *eventCreators;
@property(nonatomic,retain) NSDate *simEndDate;
@property(nonatomic,retain) FiscalYearDigest *digest;

@end
