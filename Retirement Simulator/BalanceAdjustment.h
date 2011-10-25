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
		double amount;
}

- (id) initWithZeroAmount;
- (id) initWithAmount:(double)theAmount;

- (void) addAdjustment:(BalanceAdjustment*)otherAdjustment;
- (void) resetToZero;

@property double amount;

- (double)totalAmount;


@end
