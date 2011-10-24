//
//  InputSummation.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputValDigestSummation.h"


@implementation InputValDigestSummation

@synthesize currentSum;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.currentSum = 0.0;
	}
	return self;
}

-(void)incrementSum:(double)amount
{
	assert(amount >= 0.0);
	self.currentSum = self.currentSum + amount;
}

-(void)resetSum
{
	self.currentSum = 0.0;
}

@end
