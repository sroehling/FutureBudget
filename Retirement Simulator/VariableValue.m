//
//  VariableValue.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValue.h"
#import "DateSensitiveValueChange.h"


@implementation VariableValue
@dynamic name;
@dynamic startingValue;
@dynamic valueChanges;

- (void)addValueChangesObject:(DateSensitiveValueChange *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"valueChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"valueChanges"] addObject:value];
    [self didChangeValueForKey:@"valueChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeValueChangesObject:(DateSensitiveValueChange *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"valueChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"valueChanges"] removeObject:value];
    [self didChangeValueForKey:@"valueChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addValueChanges:(NSSet *)value {    
    [self willChangeValueForKey:@"valueChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"valueChanges"] unionSet:value];
    [self didChangeValueForKey:@"valueChanges" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeValueChanges:(NSSet *)value {
    [self willChangeValueForKey:@"valueChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"valueChanges"] minusSet:value];
    [self didChangeValueForKey:@"valueChanges" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (NSString*) valueDescription
{
    return @"Variable value";
}


@end
