//
//  DefaultScenario.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Scenario.h"

@class SharedAppValues;

extern NSString * const DEFAULT_SCENARIO_ENTITY_NAME;

@interface DefaultScenario : Scenario {
@private
}

// Inverse relationship
@property (nonatomic, retain) SharedAppValues * sharedAppValsDefaultScenario;


@end
