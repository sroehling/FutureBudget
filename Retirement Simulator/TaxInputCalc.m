//
//  TaxInputCalc.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxInputCalc.h"
#import "TaxInput.h"
#import "ItemizedTaxAmt.h"
#import "ItemizedTaxAmts.h"
#import "ItemizedTaxCalcPopulator.h"
#import "SimParams.h"
#import "ItemizedTaxCalcEntries.h"
#import "TaxBracketCalc.h"
#import "IncomeSimInfo.h"
#import "DigestEntryProcessingParams.h"
#import "WorkingBalanceMgr.h"
#import "SimInputHelper.h"
#import "InputValDigestSummation.h"
#import "InputValDigestSummations.h"

@implementation TaxInputCalc

@synthesize taxInput;

@synthesize incomeCalcEntries;
@synthesize adjustmentCalcEntries;
@synthesize deductionCalcEntries;
@synthesize creditCalcEntries;

@synthesize effectiveTaxRate;
@synthesize taxBracketCalc;
@synthesize simParams;
@synthesize taxesPaid;

#define MAX_TAX_CALC_ITERS 5


-(id)initWithTaxInput:(TaxInput*)theTaxInput andSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theTaxInput != nil);
		self.taxInput = theTaxInput;
		
		assert(theSimParams != nil);
		self.simParams = theSimParams;
		
			
		self.taxBracketCalc = [[[TaxBracketCalc alloc] initWithTaxBracket:theTaxInput.taxBracket] autorelease];
		self.effectiveTaxRate = 0.0;
		
		self.taxesPaid = [[[InputValDigestSummation alloc] init] autorelease];
		[theSimParams.digestSums addDigestSum:self.taxesPaid];

	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)configTaxCalcEntries:(SimParams*)theSimParams
{
	self.incomeCalcEntries = [[[ItemizedTaxCalcEntries alloc] initWithSimParams:theSimParams 
		andItemizedTaxAmts:self.taxInput.itemizedIncomeSources] autorelease];
		
	self.adjustmentCalcEntries = [[[ItemizedTaxCalcEntries alloc] initWithSimParams:theSimParams 
		andItemizedTaxAmts:self.taxInput.itemizedAdjustments] autorelease];
		
	self.deductionCalcEntries = [[[ItemizedTaxCalcEntries alloc] initWithSimParams:theSimParams 
		andItemizedTaxAmts:self.taxInput.itemizedDeductions] autorelease];
		
	self.creditCalcEntries = [[[ItemizedTaxCalcEntries alloc] initWithSimParams:theSimParams 
		andItemizedTaxAmts:self.taxInput.itemizedCredits] autorelease];

}


-(void)updateEffectiveTaxRate:(NSDate*)currentDate
	andLastDayOfTaxYear:(NSDate*)lastDayOfTaxYear
{
	double grossIncome = [self.incomeCalcEntries calcTotalYearlyItemizedAmt];
	assert(grossIncome >= 0.0);
	
	double adjustments = [self.adjustmentCalcEntries calcTotalYearlyItemizedAmt];
	assert(adjustments >= 0.0);
	double adjustedGrossIncome = MAX(0.0,grossIncome - adjustments);
	
	double exemptions = [SimInputHelper multiScenRateAdjustedAmount:self.taxInput.exemptionAmt 
		andMultiScenRate:self.taxInput.exemptionGrowthRate asOfDate:currentDate 
		sinceDate:self.simParams.simStartDate forScenario:self.simParams.simScenario];
	assert(exemptions >= 0.0);
	
	double itemizedDeductions = [self.deductionCalcEntries calcTotalYearlyItemizedAmt];
	assert(itemizedDeductions >= 0.0);
	double stdDeduction = [SimInputHelper multiScenRateAdjustedAmount:self.taxInput.stdDeductionAmt andMultiScenRate:self.taxInput.stdDeductionGrowthRate asOfDate:currentDate 
		sinceDate:self.simParams.simStartDate forScenario:self.simParams.simScenario];
	assert(stdDeduction >= 0.0);
	double actualDeduction = MAX(stdDeduction,itemizedDeductions);
	
	double taxableIncome = MAX(0.0,adjustedGrossIncome - exemptions - actualDeduction);

	
	double credits = [self.creditCalcEntries calcTotalYearlyItemizedAmt];
	assert(credits >= 0.0);
	
	// TBD - What do we do with the credit amount, if it exceeds the tax due?
	
	self.effectiveTaxRate = [self.taxBracketCalc calcEffectiveTaxRateForGrossIncome:grossIncome 
		andTaxableIncome:taxableIncome withCredits:credits andSimParams:self.simParams 
			andCurrentDate:currentDate andLastDayOfTaxYear:lastDayOfTaxYear];
}

-(void)processDailyTaxPmt:(DigestEntryProcessingParams*)processingParams
{
	assert(processingParams!=nil);
	
	// This initial dailyTaxableAmount will include the processing of digest entries for everything
	// except the tax payments themselves (e.g., expenses, income, account interest, etc.)
	double totalAccruedTaxableIncomeCurrIter = [self.incomeCalcEntries dailyItemizedAmnt:processingParams.dayIndex];
	double taxableIncomeCurrIter = totalAccruedTaxableIncomeCurrIter;
	double taxDueCurrIter = taxableIncomeCurrIter * self.effectiveTaxRate;
	
	NSInteger numIter = 0;
	while((taxDueCurrIter > 0.0) && (numIter < MAX_TAX_CALC_ITERS))
	{
		// Process the payment for the taxes due
		[processingParams.workingBalanceMgr decrementBalanceFromFundingList:taxDueCurrIter 
			asOfDate:processingParams.currentDate];
		[self.taxesPaid adjustSum:taxDueCurrIter onDay:processingParams.dayIndex];
	
		// After paying the taxes on the income for the current iteration, recalculate
		// the total accrued taxable income in totalTaxableIncomeAccrued. totalTaxableIncomeAccrued
		// Will include any additonal taxable income which has accrued for withdrawals
		// to pay the taxes.
		double totalTaxableIncomeAccruedPrevIter = totalAccruedTaxableIncomeCurrIter;
		totalAccruedTaxableIncomeCurrIter = [self.incomeCalcEntries dailyItemizedAmnt:processingParams.dayIndex];
		assert(totalAccruedTaxableIncomeCurrIter >= totalTaxableIncomeAccruedPrevIter);
		taxableIncomeCurrIter = totalAccruedTaxableIncomeCurrIter - totalTaxableIncomeAccruedPrevIter;
		taxDueCurrIter = taxableIncomeCurrIter * self.effectiveTaxRate;
	
		numIter++;
	}
	
}

-(void)dealloc
{
	[taxInput release];
	[simParams release];
	
	[incomeCalcEntries release];
	[adjustmentCalcEntries release];
	[deductionCalcEntries release];
	[creditCalcEntries release];
	
	[taxBracketCalc release];
	
	[taxesPaid release];
	[super dealloc];
}

@end
