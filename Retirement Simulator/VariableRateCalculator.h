//
//  VariableRateCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VariableRateCalculator : NSObject {
    @private
		NSArray *variableRates;
		NSDate *startDate;
}

@property(nonatomic,retain) NSArray *variableRates; 
@property(nonatomic,retain) NSDate *startDate;

- (id)initWithRates:(NSMutableSet*)rates andStartDate:(NSDate*)theStart;
- (double) valueMultiplierForDay:(unsigned int)daysOffsetFromStart;
- (double)valueMultiplierForDate:(NSDate*)theDate;
- (double)valueMultiplierBetweenStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate;

@end
