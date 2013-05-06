//
//  ItemizedTaxCalcPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxCalcPopulator.h"

#import "ItemizedTaxAmt.h"
#import "SimParams.h"
#import "InputSimInfoCltn.h"
#import "ItemizedTaxAmt.h"
#import "ItemizedTaxCalcEntry.h"
#import "SimInputHelper.h"

#import "IncomeInput.h"
#import "IncomeItemizedTaxAmt.h"
#import "IncomeSimInfo.h"

#import "ExpenseInput.h"
#import "ExpenseItemizedTaxAmt.h"
#import "ExpenseSimInfo.h"

#import "Account.h"
#import "AccountContribItemizedTaxAmt.h"
#import "AccountWithdrawalItemizedTaxAmt.h"

#import "AssetInput.h"
#import "AssetSimInfo.h"
#import "AssetGainItemizedTaxAmt.h"

#import "Account.h"
#import "AccountInterestItemizedTaxAmt.h"
#import "AccountSimInfo.h"
#import "AccountDividendItemizedTaxAmt.h"

#import "LoanInput.h"
#import "LoanSimInfo.h"
#import "LoanInterestItemizedTaxAmt.h"

#import "TaxInput.h"
#import "TaxInputCalc.h"
#import "TaxesPaidItemizedTaxAmt.h"

#import "InterestBearingWorkingBalance.h"


@implementation ItemizedTaxCalcPopulator

@synthesize simParams;
@synthesize calcEntry;

-(double)resolveTaxablePercent:(ItemizedTaxAmt*)itemizedTaxAmt
{
	double applicableTaxablePerc = 
		[SimInputHelper multiScenFixedVal:itemizedTaxAmt.multiScenarioApplicablePercent 
		andScenario:self.simParams.simScenario];
	assert(applicableTaxablePerc >= 0.0);
	assert(applicableTaxablePerc <= 100.0);
	applicableTaxablePerc = applicableTaxablePerc / 100.0;
	return applicableTaxablePerc;
	
}

-(void)visitIncomeItemizedTaxAmt:(IncomeItemizedTaxAmt*)itemizedTaxAmt
{
	IncomeSimInfo *simInfo = [self.simParams.incomeInfo getSimInfo:itemizedTaxAmt.income];
	double taxPerc = [self resolveTaxablePercent:itemizedTaxAmt];
	
	self.calcEntry = [[[ItemizedTaxCalcEntry alloc] initWithTaxPerc:taxPerc andDigestSum:simInfo.digestSum] autorelease];
	
}

-(void)visitExpenseItemizedTaxAmt:(ExpenseItemizedTaxAmt*)itemizedTaxAmt
{
	ExpenseSimInfo *simInfo = [self.simParams.expenseInfo 
		getSimInfo:itemizedTaxAmt.expense];
	double taxPerc = [self resolveTaxablePercent:itemizedTaxAmt];
	
	self.calcEntry = [[[ItemizedTaxCalcEntry alloc] initWithTaxPerc:taxPerc andDigestSum:simInfo.digestSum] autorelease];
	
}

-(void)visitAccountInterestItemizedTaxAmt:(AccountInterestItemizedTaxAmt *)itemizedTaxAmt
{
	AccountSimInfo *simInfo = [self.simParams.acctInfo getSimInfo:itemizedTaxAmt.account];
	double taxPerc = [self resolveTaxablePercent:itemizedTaxAmt];
	
	self.calcEntry = [[[ItemizedTaxCalcEntry alloc] initWithTaxPerc:taxPerc andDigestSum:simInfo.acctBal.accruedInterest] autorelease];
}

-(void)visitAccountDividendItemizedTaxAmt:(AccountDividendItemizedTaxAmt *)itemizedTaxAmt
{
	assert(0); // not implemented yet - need to define digest sums for dividend amounts
	
	// TODO - Populate with information for account dividends

/*
	AccountSimInfo *simInfo = [self.simParams.acctInfo getSimInfo:itemizedTaxAmt.account];
	double taxPerc = [self resolveTaxablePercent:itemizedTaxAmt];
	
	
	self.calcEntry = [[[ItemizedTaxCalcEntry alloc] initWithTaxPerc:taxPerc andDigestSum:simInfo.acctBal.accruedDividends] autorelease];
*/
}

-(void)visitAccountContribItemizedTaxAmt:(AccountContribItemizedTaxAmt *)itemizedTaxAmt
{
	NSLog(@"Initializing tax amount: %@",itemizedTaxAmt.account.name);
	AccountSimInfo *simInfo = [self.simParams.acctInfo getSimInfo:itemizedTaxAmt.account];
	double taxPerc = [self resolveTaxablePercent:itemizedTaxAmt];
	
	self.calcEntry = [[[ItemizedTaxCalcEntry alloc] initWithTaxPerc:taxPerc 
		andDigestSum:simInfo.acctBal.contribs] autorelease];

}

-(void)visitAccountWithdrawalItemizedTaxAmt:(AccountWithdrawalItemizedTaxAmt *)itemizedTaxAmt
{
	AccountSimInfo *simInfo = [self.simParams.acctInfo
		getSimInfo:itemizedTaxAmt.account];
	double taxPerc = [self resolveTaxablePercent:itemizedTaxAmt];
	
	self.calcEntry = [[[ItemizedTaxCalcEntry alloc] initWithTaxPerc:taxPerc 
		andDigestSum:simInfo.acctBal.withdrawals] autorelease];

}

-(void)visitAssetGainItemizedTaxAmt:(AssetGainItemizedTaxAmt *)itemizedTaxAmt
{
	AssetSimInfo *simInfo = [self.simParams.assetInfo
		getSimInfo:itemizedTaxAmt.asset];
	double taxPerc = [self resolveTaxablePercent:itemizedTaxAmt];
	
	
	self.calcEntry = [[[ItemizedTaxCalcEntry alloc] initWithTaxPerc:taxPerc 
		andDigestSum:simInfo.sumGainsLosses] autorelease];
		
	// Any asset losses are zeroed out for purposes of computing taxes.
	self.calcEntry.zeroOutNegativeVals = TRUE;
}

-(void)visitLoanInterestItemizedTaxAmt:(LoanInterestItemizedTaxAmt *)itemizedTaxAmt
{
	LoanSimInfo *simInfo = [self.simParams.loanInfo getSimInfo:itemizedTaxAmt.loan];
	double taxPerc = [self resolveTaxablePercent:itemizedTaxAmt];

	self.calcEntry = [[[ItemizedTaxCalcEntry alloc] initWithTaxPerc:taxPerc 
		andDigestSum:simInfo.loanBalance.accruedInterest] autorelease];	
}

-(void)visitTaxesPaidItemizedTaxAmt:(TaxesPaidItemizedTaxAmt *)itemizedTaxAmt
{
	TaxInputCalc *taxCalc = [self.simParams.taxInfo getSimInfo:itemizedTaxAmt.tax];
	double taxPerc = [self resolveTaxablePercent:itemizedTaxAmt];
	
	self.calcEntry = [[[ItemizedTaxCalcEntry alloc] initWithTaxPerc:taxPerc 
		andDigestSum:taxCalc.taxesPaid] autorelease];
}


-(id)initWithSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theSimParams != nil);
		self.simParams = theSimParams;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(ItemizedTaxCalcEntry*)populateItemizedTaxCalc:(ItemizedTaxAmt*)itemizedTaxAmt 
	fromSimParams:(SimParams*)theSimParams
{
	self.calcEntry = nil;
	[itemizedTaxAmt acceptVisitor:self];
	assert(self.calcEntry != nil);
	return self.calcEntry;
}

-(void)dealloc
{
	[simParams release];
	[calcEntry release];
	[super dealloc];
}

@end
