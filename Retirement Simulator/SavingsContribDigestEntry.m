//
//  SavingsContribDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsContribDigestEntry.h"


@implementation SavingsContribDigestEntry

@synthesize workingBalance;
@synthesize contribAmount;


- (id) initWithWorkingBalance:(SavingsWorkingBalance*)theBalance andContribAmount:(double)theAmount
{
	self = [super init];
	if(self)
	{
		assert(theBalance != nil);
		self.workingBalance = theBalance;
		
		assert(theAmount >= 0.0);
		contribAmount = theAmount;
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
}

@end
