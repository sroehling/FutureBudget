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


@class MultiScenarioInputValue;
@class MultiScenarioGrowthRate;
@class MultiScenarioAmount;
@class MultiScenarioSimDate;
@class MultiScenarioSimEndDate;


extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_EVENT_REPEAT_FREQUENCY_KEY;
extern NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_CASH_FLOW_ENABLED_KEY;

@interface CashFlowInput : Input {
@private
}


@property(nonatomic,retain) MultiScenarioSimDate *startDate;
@property(nonatomic,retain) MultiScenarioSimEndDate *endDate;
@property(nonatomic,retain) MultiScenarioAmount *amount;
@property(nonatomic,retain) MultiScenarioGrowthRate *amountGrowthRate;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioEventRepeatFrequency;
@property(nonatomic,retain) MultiScenarioInputValue *multiScenarioCashFlowEnabled;


@end

