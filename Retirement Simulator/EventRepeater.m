//
//  EventRepeater.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventRepeater.h"
#import "EventRepeatFrequency.h"


@implementation EventRepeater

- (id) initWithEventRepeatFrequency:(EventRepeatFrequency*)repeatFrequency
 andStartDate:(NSDate*)theStartDate;
{
    assert(repeatFrequency!=nil);
    assert(theStartDate!=nil);

    self = [super init];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        repeatOffsetComponents = [[NSDateComponents alloc] init];
        
        EventPeriod periodEnum = 
            (EventPeriod)[[repeatFrequency period] intValue];
        int periodMultiply = [[repeatFrequency periodMultiplier] intValue];
        assert(periodMultiply >=0);
        repeatOnce = false;
                
        switch (periodEnum) {
            case kEventPeriodOnce:
                assert(periodMultiply == 1);
                repeatOnce = true;
                break;
            case kEventPeriodDay:
                assert(periodMultiply > 0);
                [repeatOffsetComponents setDay:periodMultiply];
                break;
            case kEventPeriodWeek:
                assert(periodMultiply > 0);
                [repeatOffsetComponents setWeek:periodMultiply];
                break;
            case kEventPeriodMonth:
                assert(periodMultiply > 0);
                [repeatOffsetComponents setMonth:periodMultiply];
                break;
            case kEventPeriodQuarter:
                assert(periodMultiply > 0);
                [repeatOffsetComponents setQuarter:periodMultiply];
                break;
            case kEventPeriodYear:
                assert(periodMultiply > 0);
                [repeatOffsetComponents setYear:periodMultiply];
                break;
                
            default:
                assert(false); // shouldn't get here - invalid/unsupported enum found
                break;
        }
        startDate = theStartDate;
        [startDate retain];
        [self reset];
        return self;
    }
    else
    {
        return nil;
    }
    
}

- (void)reset
{
    repeatCount = 0;
    currentDate = [startDate copy];
    [currentDate retain];
}

- (NSDate*)nextDate
{
    if(repeatOnce)
    {
        if(repeatCount > 0)
        {
            return nil;
        }
        else
        {
            repeatCount++;
            return startDate;
        }
    }
    else
    {
        if(repeatCount == 0)
        {
            // No need to increment first, dates are the same
            repeatCount++;
           return currentDate;
        }
        else{
            // TODO - This currently defaults to repeating forever. We also
            // need support repeating for a finite time period
            NSDate *lastDate = currentDate;
            currentDate = [gregorian dateByAddingComponents:repeatOffsetComponents 
                 toDate:lastDate options:0];
            [lastDate release];
            [currentDate retain];
            repeatCount++;
            return currentDate;
        }        
    }
}


-(void)dealloc {
    [dateFormatter release];
    [repeatOffsetComponents release];
    [gregorian release];
    [startDate release];
    [currentDate release];
    [super dealloc];
}



@end
