//
//  Account.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Account.h"
#import "InputVisitor.h"

#import "AccountInterestItemizedTaxAmt.h"
#import "AccountWithdrawalItemizedTaxAmt.h"
#import "AccountContribItemizedTaxAmt.h"


NSString * const ACCOUNT_STARTING_BALANCE_KEY = @"startingBalance";
NSString * const ACCOUNT_ENTITY_NAME = @"Account";
NSString * const ACCOUNT_INPUT_DEFAULT_ICON_NAME = @"piggy.png";

@implementation Account

@dynamic startingBalance;
@dynamic contribAmount;
@dynamic contribGrowthRate;

@dynamic contribRepeatFrequency;
@dynamic contribStartDate;
@dynamic contribEndDate;
@dynamic contribEnabled;

@dynamic deferredWithdrawalsEnabled;
@dynamic deferredWithdrawalDate;
@dynamic interestRate;


@dynamic withdrawalPriority;
@dynamic limitWithdrawalExpenses;

// Inverse Relationships
@dynamic accountWithdrawalItemizedTaxAmt;
@dynamic accountInterestItemizedTaxAmt;
@dynamic accountContribItemizedTaxAmt;
@dynamic acctTransferEndpointAcct;

- (void)addAccountWithdrawalItemizedTaxAmtObject:(AccountWithdrawalItemizedTaxAmt *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accountWithdrawalItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accountWithdrawalItemizedTaxAmt"] addObject:value];
    [self didChangeValueForKey:@"accountWithdrawalItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAccountWithdrawalItemizedTaxAmtObject:(AccountWithdrawalItemizedTaxAmt *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accountWithdrawalItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accountWithdrawalItemizedTaxAmt"] removeObject:value];
    [self didChangeValueForKey:@"accountWithdrawalItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAccountWithdrawalItemizedTaxAmt:(NSSet *)value {    
    [self willChangeValueForKey:@"accountWithdrawalItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accountWithdrawalItemizedTaxAmt"] unionSet:value];
    [self didChangeValueForKey:@"accountWithdrawalItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAccountWithdrawalItemizedTaxAmt:(NSSet *)value {
    [self willChangeValueForKey:@"accountWithdrawalItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accountWithdrawalItemizedTaxAmt"] minusSet:value];
    [self didChangeValueForKey:@"accountWithdrawalItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addAccountInterestItemizedTaxAmtObject:(AccountInterestItemizedTaxAmt *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accountInterestItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accountInterestItemizedTaxAmt"] addObject:value];
    [self didChangeValueForKey:@"accountInterestItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAccountInterestItemizedTaxAmtObject:(AccountInterestItemizedTaxAmt *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accountInterestItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accountInterestItemizedTaxAmt"] removeObject:value];
    [self didChangeValueForKey:@"accountInterestItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAccountInterestItemizedTaxAmt:(NSSet *)value {    
    [self willChangeValueForKey:@"accountInterestItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accountInterestItemizedTaxAmt"] unionSet:value];
    [self didChangeValueForKey:@"accountInterestItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAccountInterestItemizedTaxAmt:(NSSet *)value {
    [self willChangeValueForKey:@"accountInterestItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accountInterestItemizedTaxAmt"] minusSet:value];
    [self didChangeValueForKey:@"accountInterestItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addAccountContribItemizedTaxAmtObject:(AccountContribItemizedTaxAmt *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accountContribItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accountContribItemizedTaxAmt"] addObject:value];
    [self didChangeValueForKey:@"accountContribItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAccountContribItemizedTaxAmtObject:(AccountContribItemizedTaxAmt *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accountContribItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accountContribItemizedTaxAmt"] removeObject:value];
    [self didChangeValueForKey:@"accountContribItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAccountContribItemizedTaxAmt:(NSSet *)value {    
    [self willChangeValueForKey:@"accountContribItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accountContribItemizedTaxAmt"] unionSet:value];
    [self didChangeValueForKey:@"accountContribItemizedTaxAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAccountContribItemizedTaxAmt:(NSSet *)value {
    [self willChangeValueForKey:@"accountContribItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accountContribItemizedTaxAmt"] minusSet:value];
    [self didChangeValueForKey:@"accountContribItemizedTaxAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



- (void)addLimitWithdrawalExpensesObject:(ExpenseInput *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"limitWithdrawalExpenses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"limitWithdrawalExpenses"] addObject:value];
    [self didChangeValueForKey:@"limitWithdrawalExpenses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeLimitWithdrawalExpensesObject:(ExpenseInput *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"limitWithdrawalExpenses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"limitWithdrawalExpenses"] removeObject:value];
    [self didChangeValueForKey:@"limitWithdrawalExpenses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addLimitWithdrawalExpenses:(NSSet *)value {    
    [self willChangeValueForKey:@"limitWithdrawalExpenses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"limitWithdrawalExpenses"] unionSet:value];
    [self didChangeValueForKey:@"limitWithdrawalExpenses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeLimitWithdrawalExpenses:(NSSet *)value {
    [self willChangeValueForKey:@"limitWithdrawalExpenses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"limitWithdrawalExpenses"] minusSet:value];
    [self didChangeValueForKey:@"limitWithdrawalExpenses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}







-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
	[inputVisitor visitAccount:self];
}





@end
