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


@implementation IncomeSimEvent

@synthesize income;
@synthesize incomeAmount;

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	NSString *currencyAmount = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.incomeAmount]];
	
    
    NSLog(@"Doing income event: %@ %@ %@",
          income.name,
          [[DateHelper theHelper].longDateFormatter stringFromDate:self.eventDate],
		  currencyAmount);
		  
	[digest.cashFlowSummations addIncome:self.incomeAmount onDate:self.eventDate];
}


- (void) dealloc
{
	[super dealloc];
	[income release];
	
}

@end
