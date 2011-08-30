//
//  YearlySimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimEventCreator.h"

@class EventRepeater;
@class SimEvent;

@interface YearlySimEventCreator :  NSObject <SimEventCreator> {
    @private
		EventRepeater *yearlyEventRepeater;
}

@property(nonatomic,retain) EventRepeater *yearlyEventRepeater;
- (SimEvent*)createSimEventOnDate:(NSDate*)eventDate;

- (id) initWithStartingMonth:(NSInteger)monthNum andStartingDay:(NSInteger)dayNum;

@end
