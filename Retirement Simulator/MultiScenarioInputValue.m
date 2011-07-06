//
//  MultiScenarioInputValue.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioInputValue.h"
#import "DataModelController.h"
#import "SharedAppValues.h"
#import "ScenarioValue.h"
#import "Scenario.h"
#import "DefaultScenario.h"
#import "DataModelController.h"
#import "SharedAppValues.h"
#import "Scenario.h"

NSString * const MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME = @"MultiScenarioInputValue";

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



-(bool)sameCoreDataObjects:(NSManagedObject*)obj1 comparedTo:(NSManagedObject*)obj2
{
	NSURL *obj1Rep = [[obj1 objectID] URIRepresentation];
	NSURL *obj2Rep = [[obj2 objectID] URIRepresentation];
	return [obj1Rep isEqual:obj2Rep];
}

-(ScenarioValue*)findScenarioValueForScenario:(Scenario*)scenario
{
    assert(scenario != nil);
	for(ScenarioValue *scenarioVal in self.scenarioVals)
	{
		if([self sameCoreDataObjects:scenarioVal.scenario comparedTo:scenario])
		{
			return scenarioVal;
		}
	}
	return nil;
	
}

-(InputValue*)findInputValueForScenarioOrDefault:(Scenario*)scenario
{
	ScenarioValue *scenarioVal = [self findScenarioValueForScenario:scenario];
	if(scenarioVal != nil)
	{
		return scenarioVal.inputValue;
	}
	else
	{
		// If a value is not found for scenario, "revert to default" and 
		// check if there is a default value
		if(![self sameCoreDataObjects:scenario 
			comparedTo:[DataModelController theDataModelController].sharedAppVals.defaultScenario])
		{
			DefaultScenario *defaultScen = [DataModelController theDataModelController].sharedAppVals.defaultScenario;
			ScenarioValue *defaultScenarioVal = [self findScenarioValueForScenario:defaultScen];
			if(defaultScenarioVal != nil)
			{
				return defaultScenarioVal.inputValue;
			}
			else
			{
				return nil;
			}
		}
		else
		{
			return nil;
		}
	}
}

-(InputValue*)getValueForCurrentOrDefaultScenario
{
	Scenario *currentScenario = [DataModelController theDataModelController].sharedAppVals.currentScenario;
	assert(currentScenario != nil);
	InputValue *inputVal = [self findInputValueForScenarioOrDefault:currentScenario];
	assert(inputVal != nil);
	return inputVal;
}

-(void)setValueForScenario:(Scenario*)scenario andInputValue:(InputValue*)inputValue
{
    assert(scenario != nil);
	assert(inputValue != nil);
	
	ScenarioValue *scenarioVal = [self findScenarioValueForScenario:scenario];
	if(scenarioVal == nil)
	{
		// If we get here, it means there isn't an existing value for the given scenario. 
		// We must a new ScenarioValue and assign it the scenario and inputValue.
		ScenarioValue *scenarioVal = (ScenarioValue*)[[DataModelController theDataModelController] 
													  insertObject:SCENARIO_VALUE_ENTITY_NAME];
		scenarioVal.scenario = scenario;
		scenarioVal.inputValue = inputValue;
		[self addScenarioValsObject:scenarioVal];		
	}
	else
	{
		scenarioVal.inputValue = inputValue;		
	}
	[[DataModelController theDataModelController] saveContext];
}

-(void)setDefaultValue:(InputValue*)inputValue
{
	DefaultScenario *defaultScen = [DataModelController theDataModelController].sharedAppVals.defaultScenario;
	assert(defaultScen != nil);
	assert(inputValue != nil);
	[self setValueForScenario:defaultScen andInputValue:inputValue];
}




@end
