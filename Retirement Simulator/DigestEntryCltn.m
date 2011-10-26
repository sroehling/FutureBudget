//
//  CashFlowSummation.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DigestEntryCltn.h"
#import "BalanceAdjustment.h"
#import "SavingsContribDigestEntry.h"
#import "LoanPmtDigestEntry.h"
#import "IncomeDigestEntry.h"

@implementation DigestEntryCltn


@synthesize isEndDateForEstimatedTaxes;
@synthesize isEstimatedTaxPaymentDay;
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



- (void)markAsEndDateForEstimatedTaxAccrual
{
	isEndDateForEstimatedTaxes = TRUE;
}

- (void)markAsEstimatedTaxPaymentDay
{
	isEstimatedTaxPaymentDay = TRUE;
}

- (void)resetEntries
{	
	[self.digestEntries removeAllObjects];
	
	isEndDateForEstimatedTaxes = FALSE;
	isEstimatedTaxPaymentDay = FALSE;
}


- (void) dealloc
{
	[super dealloc];
	[digestEntries release];
}

@end
