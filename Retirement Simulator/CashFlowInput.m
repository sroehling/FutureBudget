//
//  CashFlowInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowInput.h"
#import "EventRepeatFrequency.h"
#import "InputVisitor.h"
#import "VariableValue.h"

NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_START_DATE_KEY = @"multiScenarioStartDate";
NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_END_DATE_KEY =
	@"multiScenarioEndDate";
NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_EVENT_REPEAT_FREQUENCY_KEY =
	@"multiScenarioEventRepeatFrequency";
NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_FIXED_START_DATE_KEY =
	@"multiScenarioFixedStartDate";
NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_FIXED_END_DATE_KEY=
	@"multiScenarioFixedEndDate";
NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_CASH_FLOW_ENABLED_KEY=
	@"multiScenarioCashFlowEnabled";


@implementation CashFlowInput

@dynamic multiScenarioFixedStartDate;
@dynamic multiScenarioFixedEndDate;
@dynamic multiScenarioStartDate;
@dynamic multiScenarioEndDate;
@dynamic amount;
@dynamic multiScenarioEventRepeatFrequency;
@dynamic multiScenarioFixedRelEndDate;
@dynamic multiScenarioCashFlowEnabled;
@dynamic amountGrowthRate;


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitCashFlow:self];
}



@end
