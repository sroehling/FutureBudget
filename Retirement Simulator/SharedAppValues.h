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
@class Cash;
@protocol DataModelInterface;
@class RelativeEndDate;
@class FixedValue;
@class DataModelController;
@class InflationRate;

extern NSString * const SHARED_APP_VALUES_ENTITY_NAME;
extern NSString * const SHARED_APP_VALUES_CURRENT_INPUT_SCENARIO_KEY;
extern NSString * const SHARED_APP_VALUES_SIM_START_DATE_KEY;
extern NSString * const SHARED_APP_VALUES_SIM_END_DATE_KEY;
extern NSString * const SHARED_APP_VALUES_DEFAULT_FIXED_SIM_END_DATE_KEY;
extern NSString * const SHARED_APP_VALUES_DEFAULT_RELATIVE_SIM_END_DATE_KEY;
extern NSString * const SHARED_APP_VALUES_ADJUST_RESULTS_FOR_INFLATION_KEY;

@interface SharedAppValues : NSManagedObject {
@private
}
@property (nonatomic, retain) NeverEndDate * sharedNeverEndDate;
@property (nonatomic, retain) DefaultScenario *defaultScenario;
@property (nonatomic,retain) Scenario *currentInputScenario;

@property(nonatomic,retain) EventRepeatFrequency *repeatOnceFreq;
@property(nonatomic,retain) EventRepeatFrequency *repeatMonthlyFreq;
@property(nonatomic,retain) EventRepeatFrequency *repeatYearlyFreq;

@property(nonatomic,retain) NSDate *simStartDate;
@property(nonatomic,retain) SimDate *simEndDate;
@property(nonatomic,retain) FixedDate *defaultFixedSimEndDate;
@property(nonatomic,retain) RelativeEndDate *defaultFixedRelativeEndDate;
@property(nonatomic,retain) Cash *cash;

@property(nonatomic,retain) FixedValue *deficitInterestRate;
@property (nonatomic, retain) InflationRate * defaultInflationRate;
@property (nonatomic, retain) NSNumber * adjustResultsForSimStartDate;


-(NSDate*)beginningOfSimStartDate;

+(SharedAppValues*)createWithDataModelInterface:(id<DataModelInterface>)dataModelInterface;
+(void)initFromDatabase;
+(SharedAppValues*)getUsingDataModelController:(DataModelController*)dataModelController;


@end
