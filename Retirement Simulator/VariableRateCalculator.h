//
//  VariableRateCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DateHelper;


@interface VariableRateCalculator : NSObject {
    @private
		NSArray *variableRates;
		NSDate *startDate;
        DateHelper *dateHelper;
}

@property(nonatomic,retain) NSArray *variableRates;
@property(nonatomic,retain) NSDate *startDate;
@property(nonatomic,retain) DateHelper *dateHelper;

- (id)initWithRates:(NSMutableSet*)rates andStartDate:(NSDate*)theStart;
- (id)initWithSingleAnnualRate:(double)theRate andStartDate:(NSDate*)theStart;

- (double) valueMultiplierForDay:(unsigned int)daysOffsetFromStart;
- (double)valueMultiplierForDate:(NSDate*)theDate;
- (double)valueMultiplierBetweenStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate;

- (VariableRateCalculator*)intersectWithVarRateCalc:(VariableRateCalculator*)otherVarRateCalc
                                    usingCutoffDate:(NSDate*)cutoffDateOtherRateCalc;

@end
