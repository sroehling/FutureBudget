//
//  YearlySimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimEventCreator.h"
#import "PeriodicSimEventCreator.h"

@class EventRepeater;
@class SimEvent;

@interface YearlySimEventCreator :  PeriodicSimEventCreator {
}

- (id) initWithStartingMonth:(NSInteger)monthNum andStartingDay:(NSInteger)dayNum
	andSimStartDate:(NSDate*)simStart;

@end
