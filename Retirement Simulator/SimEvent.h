//
//  SimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SimEventCreator;

@protocol SimEvent <NSObject>

// Do the actual event
- (void)doSimEvent;

// When the event will take place
@property (nonatomic, retain) NSDate *eventDate;

// The event creator which created this event
// After an event has been processed/done, this is
// used to create the next event in the series for the
// given event creator.
//
// Note the SimEvent doesn't own the event creator, so a weak reference
// is made to the originating event creator (via "assign" setter 
// semantics for the property).
@property (nonatomic, assign) id<SimEventCreator> originatingEventCreator;

@end
