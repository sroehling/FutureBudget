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


-(id)initWithTaxInput:(TaxInput*)theTaxInput andSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theTaxInput != nil);
		self.taxInput = theTaxInput;
		
		assert(theSimParams != nil);
		self.simParams = theSimParams;
		
		self.incomeCalcEntries = [[[ItemizedTaxCalcEntries alloc] initWithSimParams:theSimParams 
			andItemizedTaxAmts:self.taxInput.itemizedIncomeSources] autorelease];
			
		self.adjustmentCalcEntries = [[[ItemizedTaxCalcEntries alloc] initWithSimParams:theSimParams 
			andItemizedTaxAmts:self.taxInput.itemizedAdjustments] autorelease];
			
		self.deductionCalcEntries = [[[ItemizedTaxCalcEntries alloc] initWithSimParams:theSimParams 
			andItemizedTaxAmts:self.taxInput.itemizedDeductions] autorelease];
			
		self.creditCalcEntries = [[[ItemizedTaxCalcEntries alloc] initWithSimParams:theSimParams 
			andItemizedTaxAmts:self.taxInput.itemizedCredits] autorelease];
			
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


-(void)updateEffectiveTaxRate:(NSDate*)currentDate
{
	double grossIncome = [self.incomeCalcEntries calcTotalYearlyItemizedAmt];
	assert(grossIncome >= 0.0);
	
	double adjustments = [self.adjustmentCalcEntries calcTotalYearlyItemizedAmt];
	assert(adjustments >= 0.0);
	double adjustedGrossIncome = MAX(0.0,grossIncome - adjustments);
	
	double exemptions = [SimInputHelper multiScenRateAdjustedAmount:self.taxInput.exemptionAmt andMultiScenRate:self.taxInput.exemptionGrowthRate asOfDate:currentDate sinceDate:self.simParams.simStartDate forScenario:self.simParams.simScenario];
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
	
	self.effectiveTaxRate = [self.taxBracketCalc calcEffectiveTaxRate:taxableIncome withCredits:credits];
}

-(void)processDailyTaxPmt:(DigestEntryProcessingParams*)processingParams
{
	assert(processingParams!=nil);
	
	double dailyTaxableAmt = [self.incomeCalcEntries dailyItemizedAmnt:processingParams.dayIndex];
	double dailyTaxDue = dailyTaxableAmt * self.effectiveTaxRate;
	if(dailyTaxDue > 0.0)
	{
		[processingParams.workingBalanceMgr decrementBalanceFromFundingList:dailyTaxDue 
			asOfDate:processingParams.currentDate];
		[self.taxesPaid adjustSum:dailyTaxDue onDay:processingParams.dayIndex];

	}
}

-(void)dealloc
{
	[super dealloc];
	[taxInput release];
	[simParams release];
	
	[incomeCalcEntries release];
	[adjustmentCalcEntries release];
	[deductionCalcEntries release];
	[creditCalcEntries release];
	
	[taxBracketCalc release];
	
	[taxesPaid release];
}

@end
