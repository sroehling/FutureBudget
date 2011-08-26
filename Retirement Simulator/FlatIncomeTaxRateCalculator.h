//
//  FlatIncomeTaxRateCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IncomeTaxRateCalculator.h"

@interface FlatIncomeTaxRateCalculator : NSObject <IncomeTaxRateCalculator> {
	@private
		double flatRate;
}

- (id)initWithRate:(double)theFlatRate;

@property(readonly) double flatRate;

@end
