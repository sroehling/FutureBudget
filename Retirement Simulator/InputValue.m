//
//  InputValue.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InputValue.h"
#import "ScenarioValue.h"

@implementation InputValue


// TODO - Need more handling for cascading deletes involving this object (and other InputValue descendents). 
// As it is implemented now, deleting a reference to this
// object may result in an orphan.


// Inverse Relationships
@dynamic scenarioValInputValues;

- (void)addScenarioValInputValuesObject:(ScenarioValue *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"scenarioValInputValues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"scenarioValInputValues"] addObject:value];
    [self didChangeValueForKey:@"scenarioValInputValues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeScenarioValInputValuesObject:(ScenarioValue *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"scenarioValInputValues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"scenarioValInputValues"] removeObject:value];
    [self didChangeValueForKey:@"scenarioValInputValues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addScenarioValInputValues:(NSSet *)value {    
    [self willChangeValueForKey:@"scenarioValInputValues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"scenarioValInputValues"] unionSet:value];
    [self didChangeValueForKey:@"scenarioValInputValues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeScenarioValInputValues:(NSSet *)value {
    [self willChangeValueForKey:@"scenarioValInputValues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"scenarioValInputValues"] minusSet:value];
    [self didChangeValueForKey:@"scenarioValInputValues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (BOOL)supportsDeletion
{
	return TRUE;
}



@end
