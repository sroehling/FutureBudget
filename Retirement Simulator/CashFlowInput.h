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
@class MultiScenarioGrowthRate;
@class MultiScenarioAmount;

extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_START_DATE_KEY;
extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_END_DATE_KEY;
extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_EVENT_REPEAT_FREQUENCY_KEY;
extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_FIXED_START_DATE_KEY;
extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_FIXED_END_DATE_KEY;
extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_CASH_FLOW_ENABLED_KEY;

@interface CashFlowInput : Input {
@private
}


// These properties hold onto a single fixed
// date value the user can select. If the user then
// selects a milestone date, he/she can come back and select
// the same fixed date, rather than the fixed
// date reverting back to zero.
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioFixedStartDate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioFixedEndDate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioFixedRelEndDate;

@property(nonatomic,retain) MultiScenarioAmount *amount;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioStartDate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioEndDate;
@property(nonatomic,retain) MultiScenarioGrowthRate *amountGrowthRate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioEventRepeatFrequency;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioCashFlowEnabled;


@end

