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
}

@property double applicableTaxPerc;
@property(nonatomic,retain) InputValDigestSummation *digestSum;

-(id)initWithTaxPerc:(double)taxPerc andDigestSum:(InputValDigestSummation*)theSum;
-(double)calcYearlyItemizedAmt;

@end
