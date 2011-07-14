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
NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_AMOUNT_KEY =
	@"multiScenarioAmount";
NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_AMOUNT_GROWTH_RATE_KEY =
	@"multiScenarioAmountGrowthRate";
NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_EVENT_REPEAT_FREQUENCY_KEY =
	@"multiScenarioEventRepeatFrequency";
NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_FIXED_START_DATE_KEY =
	@"multiScenarioFixedStartDate";
NSString * const CASH_FLOW_INPUT_MULTI_SCENARIO_FIXED_END_DATE_KEY=
	@"multiScenarioFixedEndDate";


@implementation CashFlowInput

@dynamic variableAmounts;
@dynamic multiScenarioFixedStartDate;
@dynamic multiScenarioFixedEndDate;
@dynamic multiScenarioStartDate;
@dynamic multiScenarioEndDate;
@dynamic multiScenarioAmount;
@dynamic multiScenarioAmountGrowthRate;
@dynamic multiScenarioEventRepeatFrequency;
@dynamic multiScenarioFixedGrowthRate;
@dynamic multiScenarioFixedAmount;


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitCashFlow:self];
}

- (void)addVariableAmountsObject:(VariableValue *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"variableAmounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"variableAmounts"] addObject:value];
    [self didChangeValueForKey:@"variableAmounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeVariableAmountsObject:(VariableValue *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"variableAmounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"variableAmounts"] removeObject:value];
    [self didChangeValueForKey:@"variableAmounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addVariableAmounts:(NSSet *)value {    
    [self willChangeValueForKey:@"variableAmounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"variableAmounts"] unionSet:value];
    [self didChangeValueForKey:@"variableAmounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeVariableAmounts:(NSSet *)value {
    [self willChangeValueForKey:@"variableAmounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"variableAmounts"] minusSet:value];
    [self didChangeValueForKey:@"variableAmounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
