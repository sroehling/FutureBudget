//
//  SharedAppValues.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NeverEndDate;
@class DefaultScenario;
@class Scenario;
@class EventRepeatFrequency;
@class SimDate;
@class FixedDate;
@class RelativeEndDate;

extern NSString * const SHARED_APP_VALUES_ENTITY_NAME;
extern NSString * const SHARED_APP_VALUES_CURRENT_INPUT_SCENARIO_KEY;
extern NSString * const SHARED_APP_VALUES_SIM_START_DATE_KEY;
extern NSString * const SHARED_APP_VALUES_SIM_END_DATE_KEY;
extern NSString * const SHARED_APP_VALUES_DEFAULT_FIXED_SIM_END_DATE_KEY;
extern NSString * const SHARED_APP_VALUES_DEFAULT_RELATIVE_SIM_END_DATE_KEY;


@interface SharedAppValues : NSManagedObject {
@private
}
@property (nonatomic, retain) NeverEndDate * sharedNeverEndDate;
@property (nonatomic, retain) DefaultScenario *defaultScenario;
@property (nonatomic,retain) Scenario *currentInputScenario;
@property(nonatomic,retain) EventRepeatFrequency *repeatOnceFreq;
@property(nonatomic,retain) NSDate *simStartDate;
@property(nonatomic,retain) SimDate *simEndDate;
@property(nonatomic,retain) FixedDate *defaultFixedSimEndDate;
@property(nonatomic,retain) RelativeEndDate *defaultFixedRelativeEndDate;

+(void)initSingleton:(SharedAppValues*)theAppVals;
+(SharedAppValues*)singleton;
+(void)initFromDatabase;

@end
