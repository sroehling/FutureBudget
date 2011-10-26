//
//  IncomeSimInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IncomeSimInfo.h"

#import "IncomeInput.h"
#import "InputValDigestSummation.h"


@implementation IncomeSimInfo

@synthesize digestSum;
@synthesize income;

-(id)initWithIncome:(IncomeInput*)theIncome
{
	self = [super init];
	if(self)
	{
		assert(theIncome!= nil);
		self.income = theIncome;

		self.digestSum = [[[InputValDigestSummation alloc] init] autorelease];
	}
	return self;
}

-(id)init
{
	assert(0); // must init with income
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[income release];
	[digestSum release];
}

@end