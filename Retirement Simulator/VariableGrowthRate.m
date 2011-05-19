//
//  VariableGrowthRate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableGrowthRate.h"
#import "GrowthRateChange.h"


@implementation VariableGrowthRate
@dynamic name;
@dynamic startingRate;
@dynamic growthRateChanges;

- (void)addGrowthRateChangesObject:(GrowthRateChange *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"growthRateChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"growthRateChanges"] addObject:value];
    [self didChangeValueForKey:@"growthRateChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeGrowthRateChangesObject:(GrowthRateChange *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"growthRateChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"growthRateChanges"] removeObject:value];
    [self didChangeValueForKey:@"growthRateChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addGrowthRateChanges:(NSSet *)value {    
    [self willChangeValueForKey:@"growthRateChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"growthRateChanges"] unionSet:value];
    [self didChangeValueForKey:@"growthRateChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeGrowthRateChanges:(NSSet *)value {
    [self willChangeValueForKey:@"growthRateChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"growthRateChanges"] minusSet:value];
    [self didChangeValueForKey:@"growthRateChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
