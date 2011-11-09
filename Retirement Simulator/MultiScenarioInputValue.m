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

@dynamic itemizedTaxAmtApplicablePerc;
@dynamic accountContribEnabled;
@dynamic accountContribRepeatFrequency;
@dynamic accountDeferredWithdrawalsEnabled;
@dynamic accountWithdrawalPriority;
@dynamic assetEnabled;
@dynamic taxEnabled;
@dynamic cashFlowEnabled;
@dynamic cashFlowEventRepeatFrequency;
@dynamic loanDownPmtEnabled;
@dynamic loanDownPmtPercent;
@dynamic loanDownPmtPercentFixed;
@dynamic loanDuration;
@dynamic loanEnabled;
@dynamic loanExtraPmtEnabled;
@dynamic loanExtraPmtFrequency;
@dynamic multiScenAmountAmount;
@dynamic multiScenarioDefaultFixedAmount;
@dynamic multiScenGrowthRateDefaultFixedGrowthRate;
@dynamic multiScenGrowthRateGrowthRate;
@dynamic multiScenSimDateDefaultSimDate;
@dynamic multiScenSimDateSimDate;
@dynamic multiScenSimEndDateDefaultFixedSimDate;
@dynamic multiScenSimEndDateFixedRelativeEndDate;
@dynamic multiScenSimEndDateSimDate;





@synthesize dataModelInterface;
@synthesize sharedAppVals;


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
		// Since this object instantiates other CoreData objects,
		// we need the ability to specify what kind of data model interace is 
		// used to create those objects and also have as a parameter the default
		// data which is referenced from this class. This is needed primarily
		// to support unit testing with this object; i.e. when creating objects
		// using an in-memory core data is necessary.
		self.dataModelInterface = [DataModelController theDataModelController];
		self.sharedAppVals = [SharedAppValues singleton];
	}
	return self;
}

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
	self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
	if(self)
	{
		self.dataModelInterface = [DataModelController theDataModelController];
		self.sharedAppVals = [SharedAppValues singleton];
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
	DefaultScenario *defaultScen = self.sharedAppVals.defaultScenario;
	assert(defaultScen != nil);
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
		Scenario *defaultScen = self.sharedAppVals.defaultScenario;
		assert(defaultScen != nil);
		
		// If a value is not found for scenario, "revert to default" and 
		// check if there is a default value
		if(![self sameCoreDataObjects:scenario comparedTo:defaultScen])
		{			
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
// TODO - This returns the value for the current *input* scenario ... need to handle differently when calculating results
	Scenario *currentScenario = self.sharedAppVals.currentInputScenario;
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
}

-(void)setDefaultValue:(InputValue*)inputValue
{
	DefaultScenario *defaultScen = self.sharedAppVals.defaultScenario;
	assert(defaultScen != nil);
	assert(inputValue != nil);
	[self setValueForScenario:defaultScen andInputValue:inputValue];
}

-(void)dealloc
{
	[super dealloc];
	[dataModelInterface release];
	[sharedAppVals release];
}



@end
