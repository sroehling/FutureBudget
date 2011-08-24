//
//  BalanceAdjustment.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BalanceAdjustment : NSObject {
    @private
		double taxFreeAmount;
		double taxableAmount;
}

- (id) initWithTaxFreeAmount:(double)theTaxFreeAmount andTaxableAmount:(double)theTaxableAmount;
- (void) addAdjustment:(BalanceAdjustment*)otherAdjustment;

@property double taxFreeAmount;
@property double taxableAmount;

- (double)totalAmount;


@end
