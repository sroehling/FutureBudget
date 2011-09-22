//
//  DateSensitiveValueVariableRateCalculatorCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DateSensitiveValueVisitor.h"

@class VariableRateCalculator;
@class DateSensitiveValue;
@class MultiScenarioInputValue;
@class Scenario;

@interface DateSensitiveValueVariableRateCalculatorCreator : NSObject <DateSensitiveValueVisitor> {
    @private
		NSMutableSet *varRates;
		NSDate *startDate;
		bool useLoanAnnualRates;
}

- (VariableRateCalculator*)createForDateSensitiveValue:(DateSensitiveValue*)dsVal 
										  andStartDate:(NSDate*)theStartDate;
										  
+(VariableRateCalculator*)createVariableRateCalc:(MultiScenarioInputValue*)multiScenDateSensitiveVal
	andStartDate:(NSDate*)calcStartDate  andScenario:(Scenario*)theScenario 
		andUseLoanAnnualRates:(bool)useLoanRates;

@property(nonatomic,retain) NSMutableSet *varRates;
@property(nonatomic,retain) NSDate *startDate;
@property bool useLoanAnnualRates;

@end
