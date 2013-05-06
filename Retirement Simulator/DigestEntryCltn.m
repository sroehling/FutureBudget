//
//  CashFlowSummation.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DigestEntryCltn.h"

@implementation DigestEntryCltn


@synthesize digestEntries;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.digestEntries = [[[NSMutableArray alloc] init] autorelease];
		
		[self resetEntries];		
	}
	return self;
}

-(void)addDigestEntry:(id<DigestEntry>)digestEntry
{
	assert(digestEntry != nil);
	[self.digestEntries addObject:digestEntry];
}


- (void)resetEntries
{	
	[self.digestEntries removeAllObjects];
}


- (void) dealloc
{
	[digestEntries release];
	[super dealloc];
}

@end
