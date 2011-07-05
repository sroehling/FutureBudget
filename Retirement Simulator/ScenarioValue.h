//
//  ScenarioValue.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const SCENARIO_VALUE_ENTITY_NAME;

@class InputValue, Scenario;

@interface ScenarioValue : NSManagedObject {
@private
}
@property (nonatomic, retain) InputValue * inputValue;
@property (nonatomic, retain) Scenario * scenario;

@end
