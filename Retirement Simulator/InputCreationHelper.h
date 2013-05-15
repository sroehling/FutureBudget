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
@class MultiScenarioSimDate;
@class MultiScenarioGrowthRate;
@class MultiScenarioSimEndDate;
@class FixedValue;
@class MultiScenarioPercent;
@class SharedAppValues;

@class DataModelController;

@interface InputCreationHelper : NSObject {
    @private
		DataModelController *dataModel;
		SharedAppValues *sharedAppVals;
}

@property(nonatomic,retain) DataModelController *dataModel;
@property(nonatomic,retain) SharedAppValues *sharedAppVals;

-(id)initWithDataModelController:(DataModelController*)theDataModel
	andSharedAppVals:(SharedAppValues*)theSharedAppVals;

// TODO - Consider making this a class which can be instantiated and parameterize 
// the Core Data method for creating the objects. This way this class can be used
// for testing as well as with a production database.
- (MultiScenarioInputValue*)multiScenFixedValWithDefault:(double)defaultVal;
- (MultiScenarioInputValue*)multiScenInputValueWithDefaultFixedVal:(MultiScenarioInputValue*)fixedVal;
- (FixedValue*)fixedValueForValue:(double)val;

- (MultiScenarioAmount*)multiScenAmountWithDefault:(double)defaultVal;
- (MultiScenarioAmount*)multiScenAmountWithWithDefaultButNoInitialVal:(double)defaultVal;
- (MultiScenarioAmount*)multiScenAmountWithNoDefaultAndNoInitialVal;


- (MultiScenarioGrowthRate*)multiScenGrowthRateWithDefault:(double)defaultVal;
- (MultiScenarioGrowthRate*)multiScenGrowthRateWithDefaultButNoInitialVal:(double)defaultVal;
- (MultiScenarioGrowthRate*)multiScenGrowthRateWithNoDefaultAndNoInitialVal;
- (MultiScenarioGrowthRate*)multiScenDefaultGrowthRate;

- (MultiScenarioPercent*)multiScenPercentWithDefault:(double)defaultVal;

- (MultiScenarioInputValue*)multiScenBoolValWithDefault:(BOOL)theDefaultVal;

- (MultiScenarioInputValue*)multiScenarioRepeatFrequencyOnce;
- (MultiScenarioInputValue*)multiScenarioRepeatFrequencyMonthly;
- (MultiScenarioInputValue*)multiScenarioRepeatFrequencyYearly;

- (MultiScenarioInputValue*)multiScenFixedDateWithDefaultToday;
- (MultiScenarioInputValue*)multiScenRelEndDateWithImmediateDefault;

- (MultiScenarioInputValue*)multiScenNeverEndDate;
- (MultiScenarioSimEndDate*)multiScenSimEndDateWithDefault:(NSDate*)defaultDate;

- (MultiScenarioSimDate*)multiScenSimDateWithDefaultToday;
- (MultiScenarioSimDate*)multiScenSimDateWithDefaultTodayButNoInitialVal;
- (MultiScenarioSimDate*)multiScenSimDateWithDefault:(NSDate*)defaultDate;
- (MultiScenarioSimDate*)multiScenSimDateWithNoDefaultAndNoInitialVal;


- (MultiScenarioSimEndDate*)multiScenSimEndDateWithDefaultNeverEndDate;

- (MultiScenarioPercent*)multiScenPercentWithDefault:(double)defaultVal;
-(MultiScenarioPercent*)multiScenDivReinvestmentPercWithDefaultSharedVal;

@end
