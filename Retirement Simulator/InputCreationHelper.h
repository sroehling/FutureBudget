//
//  InputCreationHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MultiScenarioInputValue;
@class MultiScenarioAmount;
@class MultiScenarioGrowthRate;

@interface InputCreationHelper : NSObject {
    
}

// TODO - Consider making this a class which can be instantiated and parameterize 
// the Core Data method for creating the objects. This way this class can be used
// for testing as well as with a production database.
+ (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal;
+ (MultiScenarioInputValue*)multiScenInputValueWithDefaultFixedVal:(MultiScenarioInputValue*)fixedVal;

+ (MultiScenarioAmount*)multiScenAmountWithDefault:(double)defaultVal;
+ (MultiScenarioGrowthRate*)multiScenGrowthRateWithDefault:(double)defaultVal;

+ (MultiScenarioInputValue*)multiScenBoolValWithDefault:(BOOL)theDefaultVal;

+ (MultiScenarioInputValue*)multiScenarioRepeatFrequencyOnce;

+ (MultiScenarioInputValue*)multiScenFixedDateWithDefaultToday;
+ (MultiScenarioInputValue*)multiScenRelEndDateWithImmediateDefault;
+ (MultiScenarioInputValue*)multiScenNeverEndDate;

@end
