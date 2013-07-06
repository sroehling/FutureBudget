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
#import "CoreDataHelper.h"

NSString * const MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME = @"MultiScenarioInputValue";

@implementation MultiScenarioInputValue

@dynamic scenarioVals;

@dynamic itemizedTaxAmtApplicablePerc;
@dynamic accountContribEnabled;
@dynamic accountContribRepeatFrequency;
@dynamic accountDeferredWithdrawalsEnabled;
@dynamic accountDividendEnabled;
@dynamic accountWithdrawalPriority;
@dynamic assetEnabled;
@dynamic taxEnabled;
@dynamic cashFlowEnabled;
@dynamic cashFlowEventRepeatFrequency;

@dynamic loanDeferredPaymentEnabled;
@dynamic loanDeferredPaymentPayInterest;
@dynamic loanDeferredPaymentSubsizedInterest;
@dynamic loanDownPmtEnabled;
@dynamic loanDownPmtPercent;
@dynamic loanDownPmtPercentFixed;
@dynamic loanDuration;
@dynamic loanEnabled;
@dynamic loanExtraPmtEnabled;

@dynamic multiScenAmountAmount;
@dynamic multiScenarioDefaultFixedAmount;
@dynamic multiScenGrowthRateDefaultFixedGrowthRate;
@dynamic multiScenGrowthRateGrowthRate;
@dynamic multiScenSimDateDefaultSimDate;
@dynamic multiScenSimDateSimDate;
@dynamic multiScenSimEndDateDefaultFixedSimDate;
@dynamic multiScenSimEndDateFixedRelativeEndDate;
@dynamic multiScenSimEndDateSimDate;
@dynamic multiScenPercentFixed;
@dynamic multiScenPercentPercent;


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


-(SharedAppValues*)sharedAppVals
{
	SharedAppValues *theAppValues = (SharedAppValues*)[CoreDataHelper fetchSingleObjectForEntityName:SHARED_APP_VALUES_ENTITY_NAME 
		inManagedObectContext:self.managedObjectContext];
	assert(theAppValues != nil);
	return theAppValues;
}

-(ScenarioValue*)findScenarioValueForScenario:(Scenario*)scenario
{
    assert(scenario != nil);
	for(ScenarioValue *scenarioVal in self.scenarioVals)
	{
		if([CoreDataHelper sameCoreDataObjects:scenarioVal.scenario comparedTo:scenario])
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

-(InputValue*)findInputValueForDefaultScenario
{
	assert(self.sharedAppVals != nil);
	
	Scenario *defaultScen = [self sharedAppVals].defaultScenario;
	assert(defaultScen != nil);
	
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


-(InputValue*)getDefaultValue
{
	InputValue *defaultScenarioVal = [self findInputValueForDefaultScenario];
	assert(defaultScenarioVal != nil);
	return defaultScenarioVal;
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
		Scenario *defaultScen = [self sharedAppVals].defaultScenario;
		assert(defaultScen != nil);
		
		// If a value is not found for scenario, "revert to default" and 
		// check if there is a default value
		if(![CoreDataHelper sameCoreDataObjects:scenario comparedTo:defaultScen])
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
	
	Scenario *currentScenario = [self sharedAppVals].currentInputScenario;
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
		ScenarioValue *newScenarioVal = (ScenarioValue*)[CoreDataHelper 
			insertObjectWithEntityName:SCENARIO_VALUE_ENTITY_NAME 
			inManagedObectContext:self.managedObjectContext];
			
		newScenarioVal.scenario = scenario;
		newScenarioVal.inputValue = inputValue;
		[self addScenarioValsObject:newScenarioVal];		
	}
	else
	{
		scenarioVal.inputValue = inputValue;		
	}
}

-(void)setDefaultValue:(InputValue*)inputValue
{
	DefaultScenario *defaultScen = [self sharedAppVals].defaultScenario;
	assert(defaultScen != nil);
	assert(inputValue != nil);
	[self setValueForScenario:defaultScen andInputValue:inputValue];
}

-(void)dealloc
{
	[super dealloc];
}


@end
