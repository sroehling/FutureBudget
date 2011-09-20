//
//  SimInputHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MultiScenarioInputValue;

@interface SimInputHelper : NSObject {
    
}

+ (double)multiScenValueAsOfDate:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	andDate:(NSDate*)resolveDate;
+ (double)multiScenVariableRateMultiplier:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	sinceStartDate:(NSDate*)startDate asOfDate:(NSDate*)asOfDate;
	
	
+ (NSDate*)multiScenFixedDate:(MultiScenarioInputValue*)multiScenDate;
+ (double)multiScenFixedVal:(MultiScenarioInputValue*)multiScenVal;
+ (bool)multiScenBoolVal:(MultiScenarioInputValue*)multiScenBool;

@end
