//
//  Scenario.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Scenario.h"
#import "ScenarioValue.h"

@implementation Scenario

@dynamic scenarioValueScenario;

- (void)addScenarioValueScenarioObject:(ScenarioValue *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"scenarioValueScenario" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"scenarioValueScenario"] addObject:value];
    [self didChangeValueForKey:@"scenarioValueScenario" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeScenarioValueScenarioObject:(ScenarioValue *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"scenarioValueScenario" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"scenarioValueScenario"] removeObject:value];
    [self didChangeValueForKey:@"scenarioValueScenario" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addScenarioValueScenario:(NSSet *)value {    
    [self willChangeValueForKey:@"scenarioValueScenario" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"scenarioValueScenario"] unionSet:value];
    [self didChangeValueForKey:@"scenarioValueScenario" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeScenarioValueScenario:(NSSet *)value {
    [self willChangeValueForKey:@"scenarioValueScenario" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"scenarioValueScenario"] minusSet:value];
    [self didChangeValueForKey:@"scenarioValueScenario" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}




- (NSString *)scenarioName
{
	assert(0); // must be overridden
	return nil;
}

@end
