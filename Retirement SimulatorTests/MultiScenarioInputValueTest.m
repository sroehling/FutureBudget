//
//  MultiScenarioInputValueTest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioInputValueTest.h"
#import "DataModelController.h"
#import "MultiScenarioInputValue.h"
#import "DataModelController.h"
#import "FixedValue.h"
#import "SharedAppValues.h"
#import "DefaultScenario.h"
#import "UserScenario.h"



@implementation MultiScenarioInputValueTest
@synthesize coreData;


- (void)setUp
{
	self.coreData = [[[DataModelController alloc] initForInMemoryStorage] autorelease];
}

- (void)tearDown
{
	[coreData release];
}

- (void)checkOneScenarioValue:(MultiScenarioInputValue*)msInputVal 
				  andScenario:(Scenario*)scenario andExpectedVal:(double)expectedVal
{
	FixedValue *fixedVal = (FixedValue*)[msInputVal findInputValueForScenarioOrDefault:scenario];
	STAssertNotNil(fixedVal, @"checkOneScenarioVal: Got nil for scenario value lookup, expecting %f",expectedVal);
	STAssertEquals(expectedVal, [fixedVal.value doubleValue], @"checkOneScenarioValue: Got %f for scenario value lookup, expecting %f",[fixedVal.value doubleValue],expectedVal);
	NSLog(@"checkOneScenarioValue: Got %f for scenario value lookup, expecting %f",[fixedVal.value doubleValue],expectedVal);
}

- (FixedValue*)genFixedVal:(double)val
{
	FixedValue *fixedVal = [[DataModelController theDataModelController] insertObject:FIXED_VALUE_ENTITY_NAME];
	fixedVal.value = [NSNumber numberWithDouble:val];
	return fixedVal;
}



- (void)testDefaultValue 
{
    
    MultiScenarioInputValue *msInputVal = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	DefaultScenario *defaultScen = [SharedAppValues singleton].defaultScenario;
	
	// Set to an initial value
	[msInputVal setValueForScenario:defaultScen andInputValue:[self genFixedVal:1.0]];
	[self checkOneScenarioValue:msInputVal andScenario:defaultScen andExpectedVal:1.0];

	// Set to a new value
	[msInputVal setValueForScenario:defaultScen andInputValue:[self genFixedVal:2.0]];
	[self checkOneScenarioValue:msInputVal andScenario:defaultScen andExpectedVal:2.0];
    
}

- (void)testUserScenario
{
    MultiScenarioInputValue *msInputVal = 
	[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	DefaultScenario *defaultScen = [SharedAppValues singleton].defaultScenario;

	UserScenario *userScen = [[DataModelController theDataModelController] insertObject:USER_SCENARIO_ENTITY_NAME];
	userScen.name = @"My scenario";
	
	// Set to an initial default value
	[msInputVal setValueForScenario:defaultScen andInputValue:[self genFixedVal:1.0]];
	
	// If a value is only set for the defualt, retrieving for a user scenario should
	// revert to default
	[self checkOneScenarioValue:msInputVal andScenario:userScen andExpectedVal:1.0];
	
	// Set and retrieve a value specific to the user scenario
	[msInputVal setValueForScenario:userScen andInputValue:[self genFixedVal:2.0]];
	[self checkOneScenarioValue:msInputVal andScenario:userScen andExpectedVal:2.0];
	
	// Even after setting a user scenario value, the default value should still be returned
	[self checkOneScenarioValue:msInputVal andScenario:defaultScen andExpectedVal:1.0];
	
	
}

@end
