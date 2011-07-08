//
//  UserScenario.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UserScenario.h"

NSString * const USER_SCENARIO_ENTITY_NAME = @"UserScenario";
NSString * const USER_SCENARIO_NAME_KEY = @"name";

@implementation UserScenario
@dynamic name;

- (NSString *)scenarioName
{
	return self.name;
}

@end