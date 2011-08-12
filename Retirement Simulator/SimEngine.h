//
//  SimEngine.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimEngine : NSObject {

    
    NSMutableArray *eventList;
    
    @private
    
    // TBD - Should these private member variable names have a "_" suffice 
    // (or whatever is conventional for objective C)
    
    NSDateFormatter *dateFormatter;
    NSCalendar *gregorian;
    NSDateComponents *resultsOffsetComponents;
    
    NSDate *nextResultsCheckpointDate;
	NSDate *simEndDate;
    
    NSMutableArray *eventCreators;
    
}

- (void)runSim;

@property (nonatomic, retain) NSMutableArray *eventCreators;
@property(nonatomic,retain) NSDate *simEndDate;

@end
