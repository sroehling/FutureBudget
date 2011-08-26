//
//  WorkingBalanceAdjustment.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingBalanceAdjustment.h"
#import "BalanceAdjustment.h"

@implementation WorkingBalanceAdjustment

@synthesize balanceAdjustment;
@synthesize interestAdjustement;

-(id)initWithBalanceAdjustment:(BalanceAdjustment*)balanceAdj
	andInterestAdjustment:(BalanceAdjustment*)interestAdj
{
	self = [super init];
	if(self)
	{
		assert(balanceAdj != nil);
		assert(interestAdj != nil);
		self.balanceAdjustment = balanceAdj;
		self.interestAdjustement= interestAdj;
	}
	return self;
}

- (id) initWithZeroAmounts
{
	return [self 
		initWithBalanceAdjustment:[[[BalanceAdjustment alloc] initWithZeroAmount] autorelease] 
		andInterestAdjustment:[[[BalanceAdjustment alloc] initWithZeroAmount] autorelease]];

}

-(id)init
{
	assert(0); // must call with balance and interest adjustment
}


- (void)addAdjustment:(WorkingBalanceAdjustment*)otherAdj
{
	[self.balanceAdjustment addAdjustment:otherAdj.balanceAdjustment];
	[self.interestAdjustement addAdjustment:otherAdj.balanceAdjustment];
}


-(void)dealloc
{
	[super dealloc];
	[balanceAdjustment release];
	[interestAdjustement release];
}

@end
