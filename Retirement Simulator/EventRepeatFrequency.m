//
//  EventRepeatFrequency.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EventRepeatFrequency.h"

#import "DataModelController.h"

NSString * const EVENT_REPEAT_FREQUENCY_ENTITY_NAME = @"EventRepeatFrequency";

@implementation EventRepeatFrequency
@dynamic period;
@dynamic periodMultiplier;


- (void)setPeriodWithPeriodEnum:(EventPeriod)thePeriod
{
    self.period = [NSNumber numberWithInt:thePeriod];
}

- (NSString*)description
{
    EventPeriod periodEnum = (EventPeriod)[[self period] intValue];
    int periodMultiply = [[self periodMultiplier] intValue];
    assert(periodMultiply >=0);

    
    NSString *descriptionStr;
    
    switch (periodEnum) {
        case kEventPeriodOnce:
            assert(periodMultiply == 1);
            descriptionStr = [NSString stringWithFormat:@"%@",@"Once"];
            break;
        case kEventPeriodDay:
            assert(periodMultiply > 0);
            if(periodMultiply == 1)
            {
                descriptionStr = [NSString stringWithFormat:@"Every %@",@"Day"];
            }
            else
            {
                descriptionStr = [NSString stringWithFormat:@"Every %d %@",periodMultiply, @"Days"];
                
            }
            break;
        case kEventPeriodWeek:
            assert(periodMultiply > 0);
            if(periodMultiply == 1)
            {
                descriptionStr = [NSString stringWithFormat:@"Every %@",@"Week"];
            }
            else
            {
                descriptionStr = [NSString stringWithFormat:@"Every %d %@",periodMultiply, @"Weeks"];
                
            }
            break;
        case kEventPeriodMonth:
            assert(periodMultiply > 0);
            if(periodMultiply == 1)
            {
                descriptionStr = [NSString stringWithFormat:@"Every %@",@"Month"];
            }
            else
            {
                descriptionStr = [NSString stringWithFormat:@"Every %d %@",periodMultiply, @"Months"];
                
            }
            break;
        case kEventPeriodQuarter:
            assert(periodMultiply > 0);
            if(periodMultiply == 1)
            {
                descriptionStr = [NSString stringWithFormat:@"Every %@",@"Quarter"];
            }
            else
            {
                descriptionStr = [NSString stringWithFormat:@"Every %d %@",periodMultiply, @"Quarters"];
                
            }
            break;
        case kEventPeriodYear:
            assert(periodMultiply > 0);
            if(periodMultiply == 1)
            {
                descriptionStr = [NSString stringWithFormat:@"Every %@",@"Year"];
            }
            else
            {
                descriptionStr = [NSString stringWithFormat:@"Every %d %@",periodMultiply, @"Years"];
                
            }
            break;
            
        default:
            assert(false); // shouldn't get here - invalid/unsupported enum found
            break;
    }
    return descriptionStr;
}

- (NSString*)inlineDescription
{
	NSString *headlineDesc = [self description];
	return [headlineDesc lowercaseString];
}

- (BOOL)eventRepeatsMoreThanOnce
{
    EventPeriod periodEnum = (EventPeriod)[[self period] intValue];
    if(periodEnum == kEventPeriodOnce)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

+ (EventRepeatFrequency *)createWithPeriod: (EventPeriod)thePeriod andMultiplier:(int)theMultiplier
{
     
	EventRepeatFrequency *repeatFrequency  = (EventRepeatFrequency*)[[DataModelController theDataModelController] insertObject:EVENT_REPEAT_FREQUENCY_ENTITY_NAME];
 								  
								  
    repeatFrequency.period = [NSNumber numberWithInt:thePeriod];
    [repeatFrequency setPeriodWithPeriodEnum:thePeriod];
    repeatFrequency.periodMultiplier = [NSNumber numberWithInt:theMultiplier];
    NSLog(@"New default repeat frequency: %@",repeatFrequency.description);
	[repeatFrequency retain];
	return repeatFrequency;

}



@end
