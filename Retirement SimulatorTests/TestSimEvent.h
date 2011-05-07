//
//  TestSimEvent.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEvent.h"

@interface TestSimEvent : NSObject <SimEvent> {
    id<SimEventCreator> originatingEventCreator;
    NSDate *eventDate;
}

- (id) initWithEventCreator:(id<SimEventCreator>)eventCreator;

@property (nonatomic, retain) NSDate *eventDate;
@property (nonatomic, assign) id<SimEventCreator> originatingEventCreator;

@end
