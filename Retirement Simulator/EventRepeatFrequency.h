//
//  EventRepeatFrequency.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum
{    
    kEventPeriodOnce    =0,    
    kEventPeriodDay     =1,    
    kEventPeriodWeek    =2,
    kEventPeriodMonth   =3,
    kEventPeriodQuarter =4,
    kEventPeriodYear    =5
}EventPeriod;


@interface EventRepeatFrequency : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * period;
@property (nonatomic, retain) NSNumber * periodMultiplier;


- (void)setPeriodWithPeriodEnum:(EventPeriod)thePeriod;
- (NSString*)description;
- (BOOL)eventRepeatsMoreThanOnce;
- (NSString*)inlineDescription;

@end


