//
//  TransferSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TransferSimEvent.h"
#import "FiscalYearDigest.h"
#import "TransferDigestEntry.h"
#import "TransferSimInfo.h"
#import "FiscalYearDigestEntries.h"

@implementation TransferSimEvent

@synthesize transferInfo;
@synthesize transferAmount;


- (void)doSimEvent:(FiscalYearDigest*)digest
{	
	TransferDigestEntry *digestEntry = [[[TransferDigestEntry alloc]
		initWithTransferInfo:self.transferInfo andTransferAmount:self.transferAmount] autorelease];
	[digest.digestEntries addDigestEntry:digestEntry onDate:self.eventDate];
}


- (void) dealloc
{
	[transferInfo release];
	[super dealloc];	
}


@end
