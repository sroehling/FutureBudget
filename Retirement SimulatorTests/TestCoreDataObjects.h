//
//  TestCoreDataObjects.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InMemoryCoreData;
@class DateSensitiveValueChange;
@class MultiScenarioInputValue;
@class Scenario;

@interface TestCoreDataObjects : NSObject {
	@private
		InMemoryCoreData *coreData;
		Scenario *testScenario;
    
}

@property(nonatomic,retain) InMemoryCoreData *coreData;
@property(nonatomic,retain) Scenario *testScenario;

- (id) initWithCoreData:(InMemoryCoreData*)theCoreData;


- (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal;
- (MultiScenarioInputValue*)multiScenInputValueWithDefaultFixedVal:(MultiScenarioInputValue*)fixedVal;
- (MultiScenarioInputValue*)multiScenFixedDateWithDefaultToday;
- (MultiScenarioInputValue*)multiScenBoolValWithDefault:(BOOL)theDefaultVal;
- (MultiScenarioInputValue*)multiScenarioRepeatFrequencyOnce;
- (MultiScenarioInputValue*)multiScenRelEndDateWithImmediateDefault;

+ (DateSensitiveValueChange*)createTestValueChange:(InMemoryCoreData*)coreData 
		andDateObj:(NSDate*)dateObj andVal:(double)val;
										   
+ (DateSensitiveValueChange*)createTestValueChange:(InMemoryCoreData*)coreData 
   andDate:(NSString*)dateStr andVal:(double)val;

@end
