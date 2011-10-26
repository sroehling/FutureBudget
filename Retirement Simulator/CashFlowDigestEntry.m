//
//  CashFlowDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowDigestEntry.h"


@implementation CashFlowDigestEntry

@synthesize amount;
@synthesize cashFlowSummation;


-(id)initWithAmount:(double)theAmount andCashFlowSummation:(InputValDigestSummation*)theSummation
{
	self = [super init];
	if(self)
	{
		assert(theAmount >= 0.0);
		self.amount = theAmount;
		
		assert(theSummation != nil);
		self.cashFlowSummation = theSummation;
	}
	return self;
}


-(id)init
{
	assert(0); // must init with amount
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[cashFlowSummation release];
}


@end
