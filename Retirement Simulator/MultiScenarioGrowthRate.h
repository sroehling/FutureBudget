//
//  MultiScenarioGrowthRate.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const MULTI_SCEN_GROWTH_RATE_ENTITY_NAME;
extern NSString * const MULTI_SCEN_GROWTH_RATE_GROWTH_RATE_KEY;

@class MultiScenarioInputValue;

@interface MultiScenarioGrowthRate : NSManagedObject {
@private
}
@property (nonatomic, retain) MultiScenarioInputValue * growthRate;
@property (nonatomic, retain) MultiScenarioInputValue * defaultFixedGrowthRate;

@end
