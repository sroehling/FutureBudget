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

@implementation TaxInputCalc

@synthesize taxInput;
@synthesize incomeCalcEntries;
@synthesize effectiveTaxRate;
@synthesize taxBracketCalc;

-(id)initWithTaxInput:(TaxInput*)theTaxInput andSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theTaxInput != nil);
		self.taxInput = theTaxInput;
		
		self.incomeCalcEntries = [[[ItemizedTaxCalcEntries alloc] initWithSimParams:theSimParams 
			andItemizedTaxAmts:self.taxInput.itemizedIncomeSources] autorelease];
			
		self.taxBracketCalc = [[[TaxBracketCalc alloc] initWithTaxBracket:theTaxInput.taxBracket] autorelease];
		self.effectiveTaxRate = 0.0;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}


-(void)updateEffectiveTaxRate
{
	double grossIncome = [self.incomeCalcEntries calcTotalYearlyItemizedAmt];
	
	// TODO - subtract off deductions, std deduction, etc. to come up with taxable income;
	double taxableIncome = grossIncome;
	self.effectiveTaxRate = [self.taxBracketCalc calcEffectiveTaxRate:taxableIncome];
}

-(void)dealloc
{
	[super dealloc];
	[taxInput release];
	[incomeCalcEntries release];
	[taxBracketCalc release];
}

@end
