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


@implementation CashFlowInput
@dynamic amount;
@dynamic variableAmounts;
@dynamic repeatFrequency;
@dynamic amountGrowthRate;
@dynamic startDate;
@dynamic fixedStartDate;
@dynamic endDate;
@dynamic fixedEndDate;
@dynamic defaultFixedGrowthRate;
@dynamic defaultFixedAmount;

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
