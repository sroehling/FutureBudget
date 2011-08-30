//
//  SimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SimEventCreator;

#define SIM_EVENT_TIE_BREAK_PRIORITY_HIGHEST 100
#define SIM_EVENT_TIE_BREAK_PRIORITY_MEDIUM 50 // default
#define SIM_EVENT_TIE_BREAK_PRIORITY_MEDIUM_LOW 25
#define SIM_EVENT_TIE_BREAK_PRIORITY_LOW 12
#define SIM_EVENT_TIE_BREAK_PRIORITY_LOWEST 0

@class FiscalYearDigest;

@interface SimEvent : NSObject {
	@private
		id<SimEventCreator> originatingEventCreator;
		NSDate *eventDate;
		NSInteger tieBreakPriority;
}

// Do the actual event
- (void)doSimEvent:(FiscalYearDigest*)digest;

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
@property NSInteger tieBreakPriority;

- (id) initWithEventCreator:(id<SimEventCreator>)eventCreator andEventDate:(NSDate*)theEventDate;

@end
