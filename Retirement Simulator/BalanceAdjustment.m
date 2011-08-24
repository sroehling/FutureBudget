//
//  BalanceAdjustment.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BalanceAdjustment.h"


@implementation BalanceAdjustment

@synthesize taxableAmount;
@synthesize taxFreeAmount;

- (id) initWithTaxFreeAmount:(double)theTaxFreeAmount andTaxableAmount:(double)theTaxableAmount;
{
	self = [super init];
	if(self)
	{
		assert(theTaxFreeAmount >= 0.0);
		self.taxFreeAmount = theTaxFreeAmount;
		
		assert(theTaxableAmount >= 0.0);
		self.taxableAmount = theTaxableAmount;
	}
	return self;
}

- (void) addAdjustment:(BalanceAdjustment*)otherAdjustment
{
	assert(otherAdjustment != nil);
	self.taxableAmount += otherAdjustment.taxableAmount;
	self.taxFreeAmount += otherAdjustment.taxFreeAmount;
}

-(id) init
{
	assert(0); // must init with amount and taxable flag
}

- (double) totalAmount
{
	return (self.taxableAmount + self.taxFreeAmount);
}

@end
