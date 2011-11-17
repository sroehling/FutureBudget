//
//  TestCoreDataObjects.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataModelController;
@class DateSensitiveValueChange;
@class MultiScenarioInputValue;
@class Scenario;

@interface TestCoreDataObjects : NSObject {
	@private
		DataModelController *coreData;
		Scenario *testScenario;
    
}

@property(nonatomic,retain) DataModelController *coreData;
@property(nonatomic,retain) Scenario *testScenario;

- (id) initWithCoreData:(DataModelController*)theCoreData;


- (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal;
- (MultiScenarioInputValue*)multiScenInputValueWithDefaultFixedVal:(MultiScenarioInputValue*)fixedVal;
- (MultiScenarioInputValue*)multiScenFixedDateWithDefaultToday;
- (MultiScenarioInputValue*)multiScenFixedDate:(NSString*)defaultDate;
- (MultiScenarioInputValue*)multiScenBoolValWithDefault:(BOOL)theDefaultVal;
- (MultiScenarioInputValue*)multiScenarioRepeatFrequencyOnce;
- (MultiScenarioInputValue*)multiScenRelEndDateWithImmediateDefault;

+ (DateSensitiveValueChange*)createTestValueChange:(DataModelController*)coreData 
		andDateObj:(NSDate*)dateObj andVal:(double)val;
										   
+ (DateSensitiveValueChange*)createTestValueChange:(DataModelController*)coreData 
   andDate:(NSString*)dateStr andVal:(double)val;

@end
