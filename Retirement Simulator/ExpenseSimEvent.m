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

@implementation ExpenseSimEvent

@synthesize expense;
@synthesize expenseAmount;

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	NSString *currencyAmount = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.expenseAmount]];
	
    
    NSLog(@"Doing expense event: %@ %@ %@",
          expense.name,
          [[DateHelper theHelper].longDateFormatter stringFromDate:self.eventDate],
		  currencyAmount);
		  
	[digest addExpense:self.expenseAmount onDate:self.eventDate];
}


- (void) dealloc
{
	[super dealloc];
	[expense release];
}

@end
