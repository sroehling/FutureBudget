//
//  MultiScenarioInputValue.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioInputValue.h"
#import "ScenarioValue.h"


@implementation MultiScenarioInputValue
@dynamic scenarioVals;

- (void)addScenarioValsObject:(ScenarioValue *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"scenarioVals" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"scenarioVals"] addObject:value];
    [self didChangeValueForKey:@"scenarioVals" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeScenarioValsObject:(ScenarioValue *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"scenarioVals" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"scenarioVals"] removeObject:value];
    [self didChangeValueForKey:@"scenarioVals" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addScenarioVals:(NSSet *)value {    
    [self willChangeValueForKey:@"scenarioVals" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"scenarioVals"] unionSet:value];
    [self didChangeValueForKey:@"scenarioVals" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeScenarioVals:(NSSet *)value {
    [self willChangeValueForKey:@"scenarioVals" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"scenarioVals"] minusSet:value];
    [self didChangeValueForKey:@"scenarioVals" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
