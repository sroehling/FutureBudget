//
//  CashFlowSummation.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashFlowSummation.h"
#import "BalanceAdjustment.h"
#import "SavingsContribDigestEntry.h"
#import "LoanPmtDigestEntry.h"

@implementation CashFlowSummation

@synthesize sumExpenses;
@synthesize sumIncome;
@synthesize savingsContribs;
@synthesize loanPmts;
@synthesize sumContributions;
@synthesize isEndDateForEstimatedTaxes;
@synthesize isEstimatedTaxPaymentDay;
@synthesize assetPurchases;
@synthesize assetSales;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.savingsContribs = [[[NSMutableArray alloc] init] autorelease];
		
		self.loanPmts = [[[NSMutableArray alloc] init] autorelease];
		
		self.assetSales = [[[NSMutableArray alloc] init] autorelease];
		self.assetPurchases = [[[NSMutableArray alloc] init] autorelease];
		
		self.sumExpenses = [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
		[self resetSummations];
		
		self.sumContributions = [[[BalanceAdjustment alloc] initWithZeroAmount] autorelease];
		
		isEndDateForEstimatedTaxes = FALSE;
		isEstimatedTaxPaymentDay = FALSE;
	}
	return self;
}

- (void)addIncome:(double)incomeAmount;
{
	assert(incomeAmount >=0.0);
	sumIncome += incomeAmount;
}

- (void)addExpense:(BalanceAdjustment*)expenseAmount
{
	assert(expenseAmount != nil);
	assert([expenseAmount totalAmount] >= 0.0);
	[sumExpenses addAdjustment:expenseAmount];
}

- (void) addSavingsContrib:(SavingsContribDigestEntry*)savingsContrib
{
	assert(savingsContrib != nil);
	[self.savingsContribs addObject:savingsContrib];
	[self.sumContributions addAdjustment:savingsContrib.contribAdjustment];
}

- (void)addLoanPmt:(LoanPmtDigestEntry*)theLoanPmt
{
	assert(theLoanPmt != nil);
	[self.loanPmts addObject:theLoanPmt];
	
}

- (void)addAssetSale:(AssetDigestEntry *)assetEntry
{
	assert(assetEntry != nil);
	[self.assetSales addObject:assetEntry];
}

- (void)addAssetPurchase:(AssetDigestEntry *)assetEntry
{
	assert(assetEntry != nil);
	[self.assetPurchases addObject:assetEntry];
}

- (void)markAsEndDateForEstimatedTaxAccrual
{
	isEndDateForEstimatedTaxes = TRUE;
}

- (void)markAsEstimatedTaxPaymentDay
{
	isEstimatedTaxPaymentDay = TRUE;
}

- (void)resetSummations
{
	sumIncome = 0.0;
	
	[sumExpenses resetToZero];
	
	[self.savingsContribs removeAllObjects];
	
	[self.loanPmts removeAllObjects];
	
	[self.assetSales removeAllObjects];
	[self.assetPurchases removeAllObjects];
	
	[self.sumContributions resetToZero];
	
	isEndDateForEstimatedTaxes = FALSE;
	isEstimatedTaxPaymentDay = FALSE;
}

-(double)totalDeductions
{
	double totalDeductableExpense = self.sumExpenses.taxFreeAmount;
	double totalDeductableContributions = self.sumContributions.taxFreeAmount;
	double totalDeductions = totalDeductableExpense + totalDeductableContributions;
	return totalDeductions;
}


- (void) dealloc
{
	[super dealloc];
	[savingsContribs release];
	[loanPmts release];
	[sumContributions release];
	[sumExpenses release];
	[assetSales release];
	[assetPurchases release];
}

@end
