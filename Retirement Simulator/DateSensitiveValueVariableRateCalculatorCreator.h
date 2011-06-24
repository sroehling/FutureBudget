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

@interface DateSensitiveValueVariableRateCalculatorCreator : NSObject <DateSensitiveValueVisitor> {
    @private
		NSMutableSet *varRates;
		NSDate *startDate;
}

- (VariableRateCalculator*)createForDateSensitiveValue:(DateSensitiveValue*)dsVal 
										  andStartDate:(NSDate*)theStartDate;

@property(nonatomic,retain) NSMutableSet *varRates;
@property(nonatomic,retain) NSDate *startDate;

@end