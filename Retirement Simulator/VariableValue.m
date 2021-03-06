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
#import "LocalizationHelper.h"


NSString * const VARIABLE_VALUE_ENTITY_NAME = @"VariableValue";
NSString * const VARIABLE_VALUE_DISPLAY_ORDER_KEY = @"displayOrder";

@implementation VariableValue
@dynamic name;
@dynamic notes;
@dynamic startingValue;
@dynamic valueChanges;
@dynamic isDefault;
@dynamic staticNameStringFileKey;
@dynamic displayOrder;

// Inverse relationship
@dynamic multiScenAmountVariableAmounts;

@synthesize isSelectedInTableView;


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
		return [NSString stringWithFormat:
			LOCALIZED_STR(@"VARIABLE_VALUE_INLINE_DESCRIPTION_FORMAT_SINGLE_VALUE"),
			valueRuntimeInfo.valueVerb,
				startingValDesc,[valueRuntimeInfo inlinePeriodDesc]];
	}
	else
	{
		return [NSString stringWithFormat:
			LOCALIZED_STR(@"VARIABLE_VALUE_INLINE_DESCRIPTION_FORMAT_MULTIPLE_VALUES"),
			valueRuntimeInfo.valueVerb,startingValDesc];
		
	}
}

- (NSString*) standaloneDescriptionWithNoName:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	NSString *startingValDesc  =[[NumberHelper theHelper] 
								 displayStrFromStoredVal:self.startingValue
								 andFormatter:valueRuntimeInfo.valueFormatter];
	if([self.valueChanges count] == 0)
	{
		return [NSString stringWithFormat:
			LOCALIZED_STR(@"VARIABLE_VALUE_STANDALONE_DESCRIPTION_FORMAT_SINGLE_VALUE_NO_NAME"),
				startingValDesc,[valueRuntimeInfo inlinePeriodDesc]];
	}
	else
	{
		return [NSString stringWithFormat:
			LOCALIZED_STR(@"VARIABLE_VALUE_STANDALONE_DESCRIPTION_FORMAT_MULTIPLE_VALUES_NO_NAME"),
			startingValDesc];
		
	}	
}


- (NSString*) standaloneDescription:(VariableValueRuntimeInfo*)valueRuntimeInfo
{
	NSString *startingValDesc  =[[NumberHelper theHelper] 
								 displayStrFromStoredVal:self.startingValue
								 andFormatter:valueRuntimeInfo.valueFormatter];
	if([self.valueChanges count] == 0)
	{
		return [NSString stringWithFormat:
			LOCALIZED_STR(@"VARIABLE_VALUE_STANDALONE_DESCRIPTION_FORMAT_SINGLE_VALUE"),
				startingValDesc,[valueRuntimeInfo inlinePeriodDesc],[self label]];
	}
	else
	{
		return [NSString stringWithFormat:
			LOCALIZED_STR(@"VARIABLE_VALUE_STANDALONE_DESCRIPTION_FORMAT_MULTIPLE_VALUES"),
			startingValDesc,[self label]];
		
	}	
}

-(void)acceptDateSensitiveValVisitor:(id<DateSensitiveValueVisitor>)dsvVisitor
{
	[super acceptDateSensitiveValVisitor:dsvVisitor];
	[dsvVisitor visitVariableValue:self]; 
}

- (NSString*)label
{
	// By default, the label is the VariableValue's name. This can be overriden, 
	// for example for default values which have a fixed label.
	if([self nameIsStaticLabel])
	{
		return LOCALIZED_STR(self.staticNameStringFileKey);
	}
	else
	{
		return self.name;
	}
}

- (BOOL)nameIsStaticLabel
{
	if((self.staticNameStringFileKey != nil) && ([self.staticNameStringFileKey length] > 0))
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

-(BOOL)supportsDeletion
{
	// Only allow deletion if there are no scenario input values referring to
	// to this value.
	if([self.isDefault boolValue])
	{
		return FALSE;
	}
	else if([self.scenarioValInputValues count] <= 0)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}


@end
