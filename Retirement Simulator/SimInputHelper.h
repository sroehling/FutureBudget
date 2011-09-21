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
	
	
+ (NSDate*)multiScenFixedDate:(MultiScenarioInputValue*)multiScenDate andScenario:(Scenario*)theScenario;

+ (double)multiScenFixedVal:(MultiScenarioInputValue*)multiScenVal andScenario:(Scenario*)theScenario;

+ (bool)multiScenBoolVal:(MultiScenarioInputValue*)multiScenBool andScenario:(Scenario*)theScenario;

@end
