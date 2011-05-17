//
//  TestSimEngine.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// TODO - Additional tests needed, include (but not limited to):
//     - Stream of multiple events
//     - Event and results happen on same date
//     - Multiple results between events
//     - Multiple events between results

#import "SimEngine.h"

#import "TestSimEngine.h"
#import "TestSimEventCreator.h"


@implementation TestSimEngine


- (void)testSimEngine {
        
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
    NSLog(@"Starting sim engine test ...");
    
    SimEngine *simEngine = [[SimEngine alloc] init ];
    [simEngine.eventCreators addObject:[[TestSimEventCreator alloc]init]];
    [simEngine runSim];
    
    NSLog(@"... Done testing sim engine");
    
    [simEngine release];
    
}

@end