//
//  SimInputHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MultiScenarioInputValue;

@class Scenario;

@interface SimInputHelper : NSObject {
    
}

+ (double)multiScenValueAsOfDate:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	andDate:(NSDate*)resolveDate andScenario:(Scenario*)theScenario;
	
+ (double)multiScenVariableRateMultiplier:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	sinceStartDate:(NSDate*)startDate asOfDate:(NSDate*)asOfDate andScenario:(Scenario*)theScenario;
	
+(double)multiScenRateAdjustedValueAsOfDate:(MultiScenarioInputValue*)multiScenAmount
	andMultiScenRate:(MultiScenarioInputValue*)multiScenGrowthRate 
	asOfDate:(NSDate*)asOfDate sinceDate:(NSDate*)startDate
	forScenario:(Scenario*)theScenario;	
	
+ (NSDate*)multiScenFixedDate:(MultiScenarioInputValue*)multiScenDate andScenario:(Scenario*)theScenario;
+(NSDate*)multiScenEndDate:(MultiScenarioInputValue*)multiScenEndDate 
	withStartDate:(MultiScenarioInputValue*)theStartDate
	andScenario:(Scenario*)theScenario;

+ (double)multiScenFixedVal:(MultiScenarioInputValue*)multiScenVal andScenario:(Scenario*)theScenario;

+ (bool)multiScenBoolVal:(MultiScenarioInputValue*)multiScenBool andScenario:(Scenario*)theScenario;

+ (double)doubleVal:(NSNumber*)numberVal;

@end
