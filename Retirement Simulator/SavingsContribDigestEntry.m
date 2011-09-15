//
//  SavingsContribDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsContribDigestEntry.h"
#import "BalanceAdjustment.h"

@implementation SavingsContribDigestEntry

@synthesize workingBalance;
@synthesize contribAmount;
@synthesize contribIsTaxable;
@synthesize contribAdjustment;


- (id) initWithWorkingBalance:(InterestBearingWorkingBalance*)theBalance 
	andContribAmount:(double)theAmount andIsTaxable:(bool)isTaxable
{
	self = [super init];
	if(self)
	{
		assert(theBalance != nil);
		self.workingBalance = theBalance;
		
		assert(theAmount >= 0.0);
		contribAmount = theAmount;

		self.contribIsTaxable = isTaxable;
		
		self.contribAdjustment = [[[BalanceAdjustment alloc] 
			initWithAmount:theAmount andIsAmountTaxable:isTaxable] autorelease];
		
	}
	return self;
}

- (id)init
{
	assert(0); // Must init with working balance and contribution amount
}

- (void) dealloc
{
	[super dealloc];
	[workingBalance release];
	[contribAdjustment release];
}

@end
