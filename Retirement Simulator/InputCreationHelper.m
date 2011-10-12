//
//  InputCreationHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputCreationHelper.h"

#import "MultiScenarioInputValue.h"
#import "FixedValue.h"
#import "DataModelController.h"


@implementation InputCreationHelper


+ (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal
{
	MultiScenarioInputValue *msFixedVal = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
    FixedValue *fixedVal = 
		(FixedValue*)[[DataModelController theDataModelController]insertObject:FIXED_VALUE_ENTITY_NAME];
    fixedVal.value = [NSNumber numberWithDouble:defaultVal];
	[msFixedVal setDefaultValue:fixedVal];
	return msFixedVal;
}


@end
