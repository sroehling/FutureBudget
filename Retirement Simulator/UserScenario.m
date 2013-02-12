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
NSString * const USER_SCENARIO_NOTES_KEY = @"notes";

@implementation UserScenario
@dynamic name;
@dynamic notes;


- (NSString *)scenarioName
{
	return self.name;
}

@end
