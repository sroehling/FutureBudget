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

@synthesize dataModelInterface;


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

-(id)init
{
	self = [super init];
	if(self)
	{
		self.dataModelInterface = [DataModelController theDataModelController];
	}
	return self;
}

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	if(self)
	{
		self.dataModelInterface = [DataModelController theDataModelController];
	}
	return self;
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

- (InputValue*)findInputValueForScenario:(Scenario*)scenario
{
	ScenarioValue *scenVal = [self findScenarioValueForScenario:scenario];
	if(scenVal != nil)
	{
		return scenVal.inputValue;
	}
	else
	{
		return nil;
	}
}

-(InputValue*)getDefaultValue
{
	DefaultScenario *defaultScen = [SharedAppValues singleton].defaultScenario;
	ScenarioValue *defaultScenarioVal = [self findScenarioValueForScenario:defaultScen];
	assert(defaultScenarioVal != nil);
	return defaultScenarioVal.inputValue;
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
			comparedTo:[SharedAppValues singleton].defaultScenario])
		{
			DefaultScenario *defaultScen = [SharedAppValues singleton].defaultScenario;
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

- (InputValue*)getValueForScenarioOrDefault:(Scenario*)theScenario
{
	assert(theScenario != nil);
	InputValue *inputVal = [self findInputValueForScenarioOrDefault:theScenario];
	assert(inputVal != nil);
	return inputVal;
}

-(InputValue*)getValueForCurrentOrDefaultScenario
{
#warning TODO - This returns the value for the current *input* scenario ... need to handle differently when calculating results
	Scenario *currentScenario = [SharedAppValues singleton].currentInputScenario;
	assert(currentScenario != nil);
	
	return [self getValueForScenarioOrDefault:currentScenario];
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
		
		assert(self.dataModelInterface != nil);
		
		ScenarioValue *scenarioVal = (ScenarioValue*)[self.dataModelInterface createDataModelObject:SCENARIO_VALUE_ENTITY_NAME];
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
	DefaultScenario *defaultScen = [SharedAppValues singleton].defaultScenario;
	assert(defaultScen != nil);
	assert(inputValue != nil);
	[self setValueForScenario:defaultScen andInputValue:inputValue];
}

-(void)dealloc
{
	[super dealloc];
	[dataModelInterface release];
}



@end
