//
//  SharedAppValues.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SharedAppValues.h"
#import "NeverEndDate.h"


NSString * const SHARED_APP_VALUES_ENTITY_NAME = @"SharedAppValues";
NSString * const SHARED_APP_VALUES_CURRENT_SCENARIO_KEY = @"currentScenario";

@implementation SharedAppValues
@dynamic sharedNeverEndDate;
@dynamic defaultScenario;
@dynamic currentScenario;

@end
