//
//  BalanceAdjustment.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BalanceAdjustment.h"


@implementation BalanceAdjustment

@synthesize amount;

- (id) initWithAmount:(double)theAmount
{
	self = [super init];
	if(self)
	{
		self.amount = theAmount;
	}
	return self;
}

- (id) initWithZeroAmount
{
	return [self initWithAmount:0.0];
}

- (void) addAdjustment:(BalanceAdjustment*)otherAdjustment
{
	assert(otherAdjustment != nil);
	self.amount += otherAdjustment.amount;
}

- (void) resetToZero
{
	amount = 0.0;
}

-(id) init
{
	assert(0); // must init with amount and taxable flag
}

- (double) totalAmount
{
	return self.amount;
}

@end
