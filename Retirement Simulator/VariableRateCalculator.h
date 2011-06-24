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
}

@property(nonatomic,retain) NSArray *variableRates; 

- (id)initWithRates:(NSMutableSet*)rates;
- (double) valueMultiplierForDay:(unsigned int)daysOffsetFromStart;

@end
