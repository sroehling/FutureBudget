//
//  TestSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"


@interface TestSimEventCreator : NSObject <SimEventCreator> {
    int numEventsCreated;
}

@property int numEventsCreated;

@end
