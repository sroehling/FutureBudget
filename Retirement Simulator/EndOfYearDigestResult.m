//
//  EndOfYearDigestResult.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EndOfYearDigestResult.h"
#import "BalanceAdjustment.h"
#import "NumberHelper.h"

@implementation EndOfYearDigestResult

@synthesize totalIncome;
@synthesize totalExpense;
@synthesize totalIncomeTaxes;

-(id) init
{
	self = [super init];
	if(self)
	{
		self.totalExpense = [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
		totalIncome = 0.0;
	}
	return self;
}

- (void)incrementTotalIncome:(double)incomeAmount
{
	assert(incomeAmount >= 0.0);
	totalIncome += incomeAmount;
}

- (void)incrementTotalIncomeTaxes:(double)taxAmount
{
	assert(taxAmount >= 0.0);
	totalIncomeTaxes += taxAmount;
}

- (void)incrementTotalExpense:(BalanceAdjustment*)theExpense
{
	assert(theExpense != nil);
	[totalExpense addAdjustment:theExpense];
}

- (void)logResults
{
	NSString *totalIncomeCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.totalIncome]];
	NSLog(@"Total Income: %@",totalIncomeCurrency);
	
	NSString *totalIncomeTaxCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.totalIncomeTaxes]];
	NSLog(@"Total Income Taxes: %@",totalIncomeTaxCurrency);

	
	NSString *totalExpenseCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:[self.totalExpense totalAmount]]];
	NSLog(@"Total Expense: %@",totalExpenseCurrency);

}

- (void) dealloc
{
	[super dealloc];
	[totalExpense release];
}

@end
