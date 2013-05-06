//
//  EventRepeatFrequency.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "InputValue.h"

@protocol DataModelInterface;
@class SharedAppValues;

extern NSString * const EVENT_REPEAT_FREQUENCY_ENTITY_NAME;

typedef enum
{    
    kEventPeriodOnce    =0,    
    kEventPeriodDay     =1,    
    kEventPeriodWeek    =2,
    kEventPeriodMonth   =3,
    kEventPeriodQuarter =4,
    kEventPeriodYear    =5
}EventPeriod;


@interface EventRepeatFrequency : InputValue {
@private
}
@property (nonatomic, retain) NSNumber * period;
@property (nonatomic, retain) NSNumber * periodMultiplier;

// Inverse relationships
@property (nonatomic, retain) SharedAppValues * sharedAppValsRepeatOnceFreq;
@property (nonatomic, retain) SharedAppValues * sharedAppValsRepeatMonthlyFreq;
@property(nonatomic,retain) SharedAppValues *sharedAppValsRepeatYearlyFreq;



- (void)setPeriodWithPeriodEnum:(EventPeriod)thePeriod;
- (NSString*)description;
- (BOOL)eventRepeatsMoreThanOnce;
- (NSString*)inlineDescription;

+ (EventRepeatFrequency*)createInDataModel:(id<DataModelInterface>)dataModel 
	andPeriod:(EventPeriod)thePeriod andMultiplier:(int)theMultiplier;

+(NSDateComponents*)periodicDateComponentFromPeriod:(EventPeriod)periodEnum;

@end




