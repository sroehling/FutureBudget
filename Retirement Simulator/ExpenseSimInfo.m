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

@implementation ExpenseSimInfo

@synthesize expense;
@synthesize digestSum;


-(id)initWithExpense:(ExpenseInput*)theExpense
{
	self = [super init];
	if(self)
	{
		assert(theExpense!= nil);
		self.expense = theExpense;

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
	[expense release];
	[digestSum release];
}


@end
