//
//  TestSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestSimEvent.h"

#include "SimEvent.h"

@implementation TestSimEvent

@synthesize originatingEventCreator,eventDate;

- (id) initWithEventCreator:(id<SimEventCreator>)eventCreator {
    self = [super init];
    if (self != nil) {
        eventDate = [[NSDate alloc]init]; // today
        originatingEventCreator = eventCreator;
   }
    return self;
}


// Do the actual event
- (void)doSimEvent
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSLog(@"Doing event: %@",[dateFormatter stringFromDate:eventDate]);
    
    [dateFormatter release];
    
}

- (void)dealloc {
    // release owned objects here
    [super dealloc]; // pretty important.
    [eventDate release];
}


@end
