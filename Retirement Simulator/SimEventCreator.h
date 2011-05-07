//
//  SimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SimEvent; // forward declare the protocol


@protocol SimEventCreator <NSObject>

// Reset everything needed for event creation.
// This should reset the event creator, such that it
// will produce the same results as a prior run.
- (void)resetSimEventCreation;

// Return the next event, or nil if no more are needed
- (id<SimEvent>) nextSimEvent;

@end
