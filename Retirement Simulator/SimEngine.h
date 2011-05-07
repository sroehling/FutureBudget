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
    
    NSDateFormatter *dateFormatter;
    NSCalendar *gregorian;
    NSDateComponents *resultsOffsetComponents;
    
    NSDate *nextResultsCheckpointDate;
    
}

- (void)runSim;

@property (nonatomic, retain) NSMutableArray *eventCreators;

@end
