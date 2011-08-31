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
#import "DateHelper.h"

@implementation EndOfYearDigestResult

@synthesize totalIncome;
@synthesize totalExpense;
@synthesize totalIncomeTaxes;
@synthesize totalInterest;
@synthesize totalWithdrawals;
@synthesize endDate;
@synthesize totalEndOfYearBalance;

-(id)initWithEndDate:(NSDate *)endOfYearDate
{
	self = [super init];
	if(self)
	{
		self.totalExpense = [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
		self.totalInterest = [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
		self.totalWithdrawals = [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
		totalIncome = 0.0;
		assert(endOfYearDate != nil);
		self.endDate = endOfYearDate;
		self.totalEndOfYearBalance = 0.0;
	}
	return self;

}

-(id) init
{
	assert(0); // must call with end date
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

- (void)incrementTotalWithdrawals:(BalanceAdjustment*)theWithdrawal
{
	assert(theWithdrawal != nil);
	[totalWithdrawals addAdjustment:theWithdrawal];
}

- (void)incrementTotalInterest:(BalanceAdjustment*)theInterest
{
	assert(theInterest != nil);
	[totalInterest addAdjustment:theInterest];
}


- (double)totalTaxableWithdrawalsAndSavingsInterest
{
	return totalInterest.taxableAmount + totalWithdrawals.taxableAmount;
}

-(double)totalDeductableExpenseAndContributions
{
	// Expenses and contributions are combined in the year end result, 
	// so all that needs to be returned is the total expense's taxFreeAmount.
	return totalExpense.taxFreeAmount;
}

- (NSInteger)yearNumber
{
	return [DateHelper yearOfDate:self.endDate];
}

- (void)logResults
{
	NSString *totalIncomeCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.totalIncome]];
	NSLog(@"Total Income: %@",totalIncomeCurrency);
	
	NSString *totalIncomeTaxCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:self.totalIncomeTaxes]];
	NSLog(@"Total Income Taxes: %@",totalIncomeTaxCurrency);

	NSString *totalInterestCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:[self.totalInterest totalAmount]]];
	NSLog(@"Total Interest: %@",totalInterestCurrency);

	NSString *totalExpenseCurrency = [[NumberHelper theHelper].currencyFormatter 
				stringFromNumber:[NSNumber numberWithDouble:[self.totalExpense totalAmount]]];
	NSLog(@"Total Expense: %@",totalExpenseCurrency);

}

- (void) dealloc
{
	[super dealloc];
	[totalExpense release];
	[totalInterest release];
	[totalWithdrawals release];
}

@end
