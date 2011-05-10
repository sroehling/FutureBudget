//
//  EventRepeatFrequency.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EventRepeatFrequency.h"


@implementation EventRepeatFrequency
@dynamic period;
@dynamic periodMultiplier;


- (void)setPeriodWithPeriodEnum:(EventPeriod)thePeriod
{
    self.period = [NSNumber numberWithInt:thePeriod];
}


@end
