//
//  IncomeSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IncomeSimEvent.h"
#import "IncomeInput.h"
#import "NumberHelper.h"
#import "DateHelper.h"
#import "FiscalYearDigest.h"
#import "CashFlowSummations.h"
#import "IncomeSimInfo.h"
#import "CashFlowDigestEntry.h"


@implementation IncomeSimEvent

@synthesize incomeInfo;
@synthesize incomeAmount;

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	NSString *currencyAmount = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.incomeAmount]];
	
    
    NSLog(@"Doing income event: %@ %@ %@",
          self.incomeInfo.income.name,
          [[DateHelper theHelper].longDateFormatter stringFromDate:self.eventDate],
		  currencyAmount);
		  
	CashFlowDigestEntry *digestEntry = [[[CashFlowDigestEntry alloc] initWithAmount:self.incomeAmount andCashFlowSummation:self.incomeInfo.digestSum] autorelease];	  
		  
	[digest.cashFlowSummations addIncome:digestEntry onDate:self.eventDate];
}


- (void) dealloc
{
	[super dealloc];
	[incomeInfo release];
	
}

@end
