//
//  VariableValue.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValue.h"
#import "DateSensitiveValueChange.h"
#import "VariableValueRuntimeInfo.h"
#import "NumberHelper.h"
#import "DateSensitiveValueVisitor.h"


NSString * const VARIABLE_VALUE_ENTITY_NAME = @"VariableValue";

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

- (NSString*) valueDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
    return [[NumberHelper theHelper] 
			displayStrFromStoredVal:self.startingValue andFormatter:valueRuntimeInfo.valueFormatter];
}

- (NSString*) valueSubtitle:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	return [self standaloneDescription:valueRuntimeInfo];
}

- (NSString*) inlineDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	NSString *startingValDesc  =[[NumberHelper theHelper] 
		displayStrFromStoredVal:self.startingValue andFormatter:valueRuntimeInfo.valueFormatter];
	if([self.valueChanges count] == 0)
	{
		return [NSString stringWithFormat:@"%@ %@%@",valueRuntimeInfo.valueVerb,
				startingValDesc,[valueRuntimeInfo inlinePeriodDesc]];
	}
	else
	{
		return [NSString stringWithFormat:@"initially %@ %@ (varies after)",valueRuntimeInfo.valueVerb,startingValDesc];
		
	}
}

- (NSString*) standaloneDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	NSString *startingValDesc  =[[NumberHelper theHelper] 
								 displayStrFromStoredVal:self.startingValue
								 andFormatter:valueRuntimeInfo.valueFormatter];
	if([self.valueChanges count] == 0)
	{
		return [NSString stringWithFormat:@"%@%@",
				startingValDesc,[valueRuntimeInfo inlinePeriodDesc]];
	}
	else
	{
		return [NSString stringWithFormat:@"Initially %@ (varies after)",startingValDesc];
		
	}	
}

-(void)acceptDateSensitiveValVisitor:(id<DateSensitiveValueVisitor>)dsvVisitor
{
	[super acceptDateSensitiveValVisitor:dsvVisitor];
	[dsvVisitor visitVariableValue:self]; 
}


@end
