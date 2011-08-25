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

- (id) initWithAmount:(double)theAmount andIsAmountTaxable:(bool)isTaxable
{
	if(isTaxable)
	{
		return [self initWithTaxFreeAmount:0.0 andTaxableAmount:theAmount];
	}
	else
	{
		return [self initWithTaxFreeAmount:theAmount andTaxableAmount:0.0];
	}
}

- (id) initWithZeroAmount
{
	return [self initWithTaxFreeAmount:0.0 andTaxableAmount:0.0];
}

- (void) addAdjustment:(BalanceAdjustment*)otherAdjustment
{
	assert(otherAdjustment != nil);
	self.taxableAmount += otherAdjustment.taxableAmount;
	self.taxFreeAmount += otherAdjustment.taxFreeAmount;
}

- (void) resetToZero
{
	taxFreeAmount = 0.0;
	taxableAmount = 0.0;
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
