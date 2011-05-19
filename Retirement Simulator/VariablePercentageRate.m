//
//  VariablePercentageRate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VariablePercentageRate.h"
#import "PercentageRateChange.h"


@implementation VariablePercentageRate
@dynamic name;
@dynamic startingRate;
@dynamic rateChanges;

- (void)addRateChangesObject:(PercentageRateChange *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"rateChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"rateChanges"] addObject:value];
    [self didChangeValueForKey:@"rateChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRateChangesObject:(PercentageRateChange *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"rateChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"rateChanges"] removeObject:value];
    [self didChangeValueForKey:@"rateChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRateChanges:(NSSet *)value {    
    [self willChangeValueForKey:@"rateChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"rateChanges"] unionSet:value];
    [self didChangeValueForKey:@"rateChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRateChanges:(NSSet *)value {
    [self willChangeValueForKey:@"rateChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"rateChanges"] minusSet:value];
    [self didChangeValueForKey:@"rateChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
