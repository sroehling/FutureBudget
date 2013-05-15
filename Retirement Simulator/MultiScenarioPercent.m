//
//  MultiScenarioPercent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/14/13.
//
//

#import "MultiScenarioPercent.h"
#import "MultiScenarioInputValue.h"

NSString * const MULTI_SCEN_PERCENT_ENTITY_NAME = @"MultiScenarioPercent";

@implementation MultiScenarioPercent

@dynamic percent;
@dynamic defaultFixedPercent;

// Inverse Relationships
@dynamic accountDividendReinvestPercent;


@end
