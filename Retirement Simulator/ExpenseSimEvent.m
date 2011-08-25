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
#import "BalanceAdjustment.h"

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
		
	bool doTaxExpense = [self.expense.taxDeductible boolValue]?FALSE:TRUE;
	BalanceAdjustment *expenseAdj = [[[BalanceAdjustment alloc] initWithAmount:self.expenseAmount andIsAmountTaxable:doTaxExpense] autorelease];
		  
	[digest addExpense:expenseAdj onDate:self.eventDate];
}


- (void) dealloc
{
	[super dealloc];
	[expense release];
}

@end
