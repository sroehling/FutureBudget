//
//  FlatIncomeTaxRateCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlatIncomeTaxRateCalculator.h"


@implementation FlatIncomeTaxRateCalculator

@synthesize flatRate;

- (id)initWithRate:(double)theFlatRate
{
	self = [super init];
	if(self)
	{
		assert(theFlatRate >= 0.0);
		assert(theFlatRate <= 1.0);
		flatRate = theFlatRate;
	}
	return self;
}

- (id) init 
{
	assert(0); // must init with rate
	return nil;
}

- (double)taxRateForGrossIncome:(double)incomeAmount andDeductions:(double)deductionAmount
{
	return self.flatRate;
}


@end
