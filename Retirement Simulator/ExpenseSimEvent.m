//
//  ExpenseSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseSimEvent.h"

#import "ExpenseInput.h"
#import "DateHelper.h"
#import "NumberHelper.h"
#import "FiscalYearDigest.h"
#import "FiscalYearDigestEntries.h"
#import "ExpenseDigestEntry.h"

@implementation ExpenseSimEvent

//@synthesize expense;
@synthesize expenseAmount;
@synthesize expenseInfo;


-(id)initWithEventCreator:(id<SimEventCreator>)eventCreator 
	andEventDate:(NSDate *)theEventDate andAmount:(double)theAmount
	andExpenseInfo:(ExpenseSimInfo*)theExpenseInfo
{
	self = [super initWithEventCreator:eventCreator andEventDate:theEventDate];
	if(self)
	{
		assert(theAmount >= 0.0);
		self.expenseAmount = theAmount;
		
		assert(theExpenseInfo != nil);
		self.expenseInfo = theExpenseInfo;
	}
	return self;
}

-(id)init
{	
	assert(0); // must init with amount and taxable flat
	return nil;
}

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	ExpenseDigestEntry *expenseEntry =
		[[[ExpenseDigestEntry alloc] initWithExpenseInfo:self.expenseInfo 
			andAmount:self.expenseAmount] autorelease];
		  
	[digest.digestEntries addDigestEntry:expenseEntry onDate:self.eventDate];
}


- (void) dealloc
{
	[super dealloc];
	[expenseInfo release];
}

@end
