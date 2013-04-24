//
//  InputValDigestSummations.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputValDigestSummations.h"
#import "InputValDigestSummation.h"

@implementation InputValDigestSummations

@synthesize inputValDigestSums;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.inputValDigestSums = [[[NSMutableArray alloc]init]autorelease];
	}
	return self;
}

-(void)addDigestSum:(InputValDigestSummation*)digestSum
{
	assert(digestSum != nil);
	[self.inputValDigestSums addObject:digestSum];
}

-(void)resetSums
{
	for(InputValDigestSummation *digestSum in self.inputValDigestSums)
	{
		[digestSum resetSum];
	}
}

-(void)rewindSumsToStartDate
{
	for(InputValDigestSummation *digestSum in self.inputValDigestSums)
	{
		[digestSum rewindSumToStartDate];
	}
}

-(void)snapshotSumsAtStartDate
{
	for(InputValDigestSummation *digestSum in self.inputValDigestSums)
	{
		[digestSum snapshotSumAtStartDate];
	}
}

-(void)dealloc
{
	[inputValDigestSums release];
	[super dealloc];
}

@end
