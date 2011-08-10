//
//  Account.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Account.h"
#import "InputVisitor.h"

NSString * const ACCOUNT_STARTING_BALANCE_KEY = @"startingBalance";
NSString * const ACCOUNT_ENTITY_NAME = @"Account";
NSString * const ACCOUNT_CONTRIB_AMOUNT_ENTITY_NAME = @"AccountContribAmount";

NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_AMOUNT_KEY = @"multiScenarioContribAmount";
NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_GROWTH_RATE_KEY = @"multiScenarioContribGrowthRate";
NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_REPEAT_FREQUENCY_KEY = @"multiScenarioContribRepeatFrequency";
NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_START_DATE_KEY = @"multiScenarioContribStartDate";
NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_END_DATE_KEY = @"multiScenarioContribEndDate";
NSString * const ACCOUNT_VARIABLE_CONTRIB_AMOUNTS_KEY = @"variableContribAmounts";

@implementation Account
@dynamic startingBalance;

@dynamic multiScenarioContribAmount;
@dynamic multiScenarioContribGrowthRate;
@dynamic multiScenarioContribRepeatFrequency;
@dynamic multiScenarioContribStartDate;
@dynamic multiScenarioContribEndDate;

@dynamic multiScenarioFixedContribAmount;
@dynamic multiScenarioFixedContribStartDate;
@dynamic multiScenarioFixedContribEndDate;
@dynamic multiScenarioFixedContribGrowthRate;
@dynamic multiScenarioFixedContribRelEndDate;

@dynamic variableContribAmounts;

- (void)addVariableContribAmountsObject:(VariableValue *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"variableContribAmounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"variableContribAmounts"] addObject:value];
    [self didChangeValueForKey:@"variableContribAmounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeVariableContribAmountsObject:(VariableValue *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"variableContribAmounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"variableContribAmounts"] removeObject:value];
    [self didChangeValueForKey:@"variableContribAmounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addVariableContribAmounts:(NSSet *)value {    
    [self willChangeValueForKey:@"variableContribAmounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"variableContribAmounts"] unionSet:value];
    [self didChangeValueForKey:@"variableContribAmounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeVariableContribAmounts:(NSSet *)value {
    [self willChangeValueForKey:@"variableContribAmounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"variableContribAmounts"] minusSet:value];
    [self didChangeValueForKey:@"variableContribAmounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
	[inputVisitor visitAccount:self];
}



@end
