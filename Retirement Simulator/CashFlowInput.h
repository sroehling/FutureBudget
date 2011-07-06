//
//  CashFlowInput.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Input.h"

@class EventRepeatFrequency;
@class DateSensitiveValue;
@class SimDate;
@class FixedDate;
@class FixedValue;
@class VariableValue;
@class MultiScenarioInputValue;

extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_START_DATE_KEY;
extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_END_DATE_KEY;
extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_AMOUNT_KEY;
extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_AMOUNT_GROWTH_RATE_KEY;
extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_EVENT_REPEAT_FREQUENCY_KEY;


@interface CashFlowInput : Input {
@private
}

@property (nonatomic,retain) NSSet* variableAmounts;

// fixedStartDate is used to hold onto a single fixed
// date value the user can select. If the user then
// selects a milestone date, he/she can come back and select
// the same fixed start date, rather than the fixed
// date reverting back to zero.
@property(nonatomic,retain) FixedDate *fixedStartDate;
@property(nonatomic,retain) FixedDate *fixedEndDate;

@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioStartDate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioEndDate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioAmount;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioAmountGrowthRate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioEventRepeatFrequency;

// defaultFixedGrowthRate serves the same purpose as 
// fixedStartDate.
@property(nonatomic,retain) FixedValue *defaultFixedGrowthRate;
@property(nonatomic,retain) FixedValue *defaultFixedAmount;


- (void)addVariableAmountsObject:(VariableValue *)value;

@end

