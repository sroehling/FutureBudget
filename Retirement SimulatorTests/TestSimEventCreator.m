//
//  TestSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestSimEventCreator.h"
#import "TestSimEvent.h"
#import "SimEventCreator.h"


@implementation TestSimEventCreator

@synthesize numEventsCreated;

- (id) init {
    self = [super init];
    if (self != nil) {
        // initializations go here.
    }
    return self;
}

- (void)resetSimEventCreation
{
    numEventsCreated = 0;
}

- (SimEvent*)nextSimEvent
{
    if(numEventsCreated == 0)
    {
        numEventsCreated = numEventsCreated + 1;
        TestSimEvent *theEvent = [[TestSimEvent alloc]initWithEventCreator:self  andEventDate:[[NSDate alloc]init]];
        [theEvent autorelease];
        
        return theEvent;
    }
    else
    {
        return nil;
    }
}

- (void)dealloc {
    // release owned objects here
    [super dealloc]; // pretty important.
    
}


@end
