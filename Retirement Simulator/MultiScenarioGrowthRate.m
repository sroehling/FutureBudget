//
//  MultiScenarioGrowthRate.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MultiScenarioGrowthRate.h"
#import "MultiScenarioInputValue.h"

NSString * const MULTI_SCEN_GROWTH_RATE_ENTITY_NAME = @"MultiScenarioGrowthRate";


NSString * const MULTI_SCEN_GROWTH_RATE_GROWTH_RATE_KEY = @"growthRate";

@implementation MultiScenarioGrowthRate
@dynamic growthRate;
@dynamic defaultFixedGrowthRate;



@end
