//
//  IncomeInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IncomeInput.h"
#import "InputVisitor.h"
#import "LocalizationHelper.h"
#import "IncomeItemizedTaxAmt.h"

 NSString * const INCOME_INPUT_ENTITY_NAME = @"IncomeInput";

@implementation IncomeInput


// Inverse Relationship
@dynamic incomeItemizedTaxAmts;

- (void)addIncomeItemizedTaxAmtsObject:(IncomeItemizedTaxAmt *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"incomeItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"incomeItemizedTaxAmts"] addObject:value];
    [self didChangeValueForKey:@"incomeItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeIncomeItemizedTaxAmtsObject:(IncomeItemizedTaxAmt *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"incomeItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"incomeItemizedTaxAmts"] removeObject:value];
    [self didChangeValueForKey:@"incomeItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addIncomeItemizedTaxAmts:(NSSet *)value {    
    [self willChangeValueForKey:@"incomeItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"incomeItemizedTaxAmts"] unionSet:value];
    [self didChangeValueForKey:@"incomeItemizedTaxAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeIncomeItemizedTaxAmts:(NSSet *)value {
    [self willChangeValueForKey:@"incomeItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"incomeItemizedTaxAmts"] minusSet:value];
    [self didChangeValueForKey:@"incomeItemizedTaxAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitIncome:self];
}

- (NSString*)inlineInputType
{
	return LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_INCOME_INLINE");
}

-(NSString*)inputTypeTitle
{
	return LOCALIZED_STR(@"INPUT_CASHFLOW_TYPE_INCOME_TITLE");
}


@end
