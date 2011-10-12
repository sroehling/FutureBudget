//
//  ItemizedTaxAmts.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmts.h"
#import "ItemizedTaxAmt.h"

NSString * const ITEMIZED_TAX_AMTS_ENTITY_NAME = @"ItemizedTaxAmts";

@implementation ItemizedTaxAmts
@dynamic itemizedAmts;

- (void)addItemizedAmtsObject:(ItemizedTaxAmt *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"itemizedAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"itemizedAmts"] addObject:value];
    [self didChangeValueForKey:@"itemizedAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeItemizedAmtsObject:(ItemizedTaxAmt *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"itemizedAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"itemizedAmts"] removeObject:value];
    [self didChangeValueForKey:@"itemizedAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addItemizedAmts:(NSSet *)value {    
    [self willChangeValueForKey:@"itemizedAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"itemizedAmts"] unionSet:value];
    [self didChangeValueForKey:@"itemizedAmts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeItemizedAmts:(NSSet *)value {
    [self willChangeValueForKey:@"itemizedAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"itemizedAmts"] minusSet:value];
    [self didChangeValueForKey:@"itemizedAmts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
