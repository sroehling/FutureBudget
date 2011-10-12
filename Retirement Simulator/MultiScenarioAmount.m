//
//  MultiScenarioAmount.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioAmount.h"
#import "MultiScenarioInputValue.h"
#import "VariableValue.h"


NSString * const MULTI_SCEN_AMOUNT_ENTITY_NAME = @"MultiScenarioAmount";
NSString * const MULTI_SCEN_AMOUNT_AMOUNT_KEY = @"amount";

@implementation MultiScenarioAmount
@dynamic amount;
@dynamic defaultFixedAmount;
@dynamic variableAmounts;



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
