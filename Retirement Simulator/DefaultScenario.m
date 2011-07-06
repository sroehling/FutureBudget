//
//  DefaultScenario.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DefaultScenario.h"
#import "LocalizationHelper.h"

NSString * const DEFAULT_SCENARIO_ENTITY_NAME = @"DefaultScenario";

@implementation DefaultScenario

- (NSString *)scenarioName
{
	return LOCALIZED_STR(@"SCENARIO_DEFAULT_SCENARIO_NAME");
}

@end
