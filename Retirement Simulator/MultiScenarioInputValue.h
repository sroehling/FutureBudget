//
//  MultiScenarioInputValue.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME;

@protocol DataModelInterface;

@class ScenarioValue;
@class Scenario;
@class InputValue;

@interface MultiScenarioInputValue : NSManagedObject {
	@private
		id<DataModelInterface> dataModelInterface;
}

@property (nonatomic, retain) NSSet* scenarioVals;

-(void)setValueForScenario:(Scenario*)scenario andInputValue:(InputValue*)inputValue;
-(void)setDefaultValue:(InputValue*)inputValue;
-(InputValue*)findInputValueForScenarioOrDefault:(Scenario*)scenario;
-(InputValue*)getValueForCurrentOrDefaultScenario;
-(InputValue*)getDefaultValue;
- (InputValue*)findInputValueForScenario:(Scenario*)scenario;
- (InputValue*)getValueForScenarioOrDefault:(Scenario*)theScenario;

@property(nonatomic,retain) id<DataModelInterface> dataModelInterface;

@end
