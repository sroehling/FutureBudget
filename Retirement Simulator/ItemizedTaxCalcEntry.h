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
}

@property double applicableTaxPerc;
@property(nonatomic,retain) InputValDigestSummation *digestSum;
@property BOOL zeroOutNegativeVals;

-(id)initWithTaxPerc:(double)taxPerc andDigestSum:(InputValDigestSummation*)theSum;
-(double)calcYearlyItemizedAmt;
-(double)dailyItemizedAmt:(NSInteger)dayIndex;

@end
