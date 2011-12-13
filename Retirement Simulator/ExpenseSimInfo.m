//
//  ExpenseSimInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseSimInfo.h"

#import "ExpenseInput.h"
#import "InputValDigestSummation.h"
#import "InputValDigestSummations.h"
#import "SimParams.h"

@implementation ExpenseSimInfo

@synthesize expense;
@synthesize digestSum;
@synthesize simParams;

-(id)initWithExpense:(ExpenseInput*)theExpense andSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		self.simParams = theSimParams;
	
		assert(theExpense!= nil);
		self.expense = theExpense;

		self.digestSum = [[[InputValDigestSummation alloc] init] autorelease];
		[theSimParams.digestSums addDigestSum:self.digestSum];
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
	[expense release];
	[digestSum release];
	[simParams release];
}


@end
