//
//  ExpenseInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseInput.h"
#import "InputVisitor.h"
#import "LocalizationHelper.h"
#import "ExpenseItemizedTaxAmt.h"

NSString * const EXPENSE_INPUT_ENTITY_NAME = @"ExpenseInput";

@implementation ExpenseInput



// Inverse Relationship
@dynamic expenseItemizedTaxAmts;
@dynamic accountLimitedWithdrawals;

- (void)addExpenseItemizedTaxAmtsObject:(ExpenseItemizedTaxAmt *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"expenseItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"expenseItemizedTaxAmts"] addObject:value];
    [self didChangeValueForKey:@"expenseItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeExpenseItemizedTaxAmtsObject:(ExpenseItemizedTaxAmt *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"expenseItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"expenseItemizedTaxAmts"] removeObject:value];
    [self didChangeValueForKey:@"expenseItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addExpenseItemizedTaxAmts:(NSSet *)value {    
    [self willChangeValueForKey:@"expenseItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"expenseItemizedTaxAmts"] unionSet:value];
    [self didChangeValueForKey:@"expenseItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeExpenseItemizedTaxAmts:(NSSet *)value {
    [self willChangeValueForKey:@"expenseItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"expenseItemizedTaxAmts"] minusSet:value];
    [self didChangeValueForKey:@"expenseItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)addAccountLimitedWithdrawalsObject:(Account *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accountLimitedWithdrawals" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accountLimitedWithdrawals"] addObject:value];
    [self didChangeValueForKey:@"accountLimitedWithdrawals" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAccountLimitedWithdrawalsObject:(Account *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accountLimitedWithdrawals" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accountLimitedWithdrawals"] removeObject:value];
    [self didChangeValueForKey:@"accountLimitedWithdrawals" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAccountLimitedWithdrawals:(NSSet *)value {    
    [self willChangeValueForKey:@"accountLimitedWithdrawals" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accountLimitedWithdrawals"] unionSet:value];
    [self didChangeValueForKey:@"accountLimitedWithdrawals" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAccountLimitedWithdrawals:(NSSet *)value {
    [self willChangeValueForKey:@"accountLimitedWithdrawals" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accountLimitedWithdrawals"] minusSet:value];
    [self didChangeValueForKey:@"accountLimitedWithdrawals" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitExpense:self];
}

- (NSString*)inlineInputType
{
	return LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_EXPENSE_INLINE");
}

-(NSString*)inputTypeTitle
{
	return LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_EXPENSE_TITLE");
}

@end
