//
//  ItemizedTaxCalcEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InputValDigestSummation;

@interface ItemizedTaxCalcEntry : NSObject {
    @private
		double applicableTaxPerc;
		InputValDigestSummation *digestSum;
		
		
		// zeroOutNegativeVals is used for taxable amounts which can either be
		// positive or negative, such as asset gains and losses. If a negative
		// value is seen, it is zeroed out if it is negative.
		BOOL zeroOutNegativeVals; // default is FALSE
		
		// invertVals is used for taxable amounts which can be negative
		// (such as the loss on an asset). This causes dailyItemizedAmt
		// and calcYearlyItemizedAmt to invert and return the sum of
		// negative values.
		BOOL invertVals; // default is FALSE
}

@property double applicableTaxPerc;
@property(nonatomic,retain) InputValDigestSummation *digestSum;
@property BOOL zeroOutNegativeVals;
@property BOOL invertVals;

-(id)initWithTaxPerc:(double)taxPerc andDigestSum:(InputValDigestSummation*)theSum;
-(double)calcYearlyItemizedAmt;
-(double)dailyItemizedAmt:(NSInteger)dayIndex;

@end
