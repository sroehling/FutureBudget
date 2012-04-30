//
//  TaxBracketCalc.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxBracketCalc.h"
#import "TaxBracket.h"
#import "TaxBracketEntry.h"
#import "CollectionHelper.h"
#import "SimInputHelper.h"
#import "SimParams.h"
#import "MultiScenarioGrowthRate.h"

@implementation TaxBracketCalc

@synthesize taxBracketEntries;
@synthesize taxBracket;

-(id)initWithTaxBracket:(TaxBracket *)theTaxBracket
{
	self = [super init];
	if(self)
	{
		assert(theTaxBracket!=nil);
		self.taxBracketEntries = [CollectionHelper setToSortedArray:theTaxBracket.taxBracketEntries 
			withKey:TAX_BRACKET_ENTRY_CUTOFF_AMOUNT_KEY];
		self.taxBracket = theTaxBracket;

	}
	return self;
}

-(id)init
{
	assert(0); // must init with tax bracket
	return nil;
}

-(double)calcEffectiveTaxRateForGrossIncome:(double)grossIncome 
	andTaxableIncome:(double)taxableIncome withCredits:(double)creditAmount
	andSimParams:(SimParams*)simParams andCurrentDate:(NSDate*)currentDate
{
	// TODO - We definitely need a unit test of this method
	assert(taxableIncome >= 0.0);
	assert(taxableIncome <= grossIncome);
	assert(creditAmount >= 0.0);
	
	
	if([self.taxBracketEntries count] == 0)
	{
		return 0.0;
	}
	else
	{
		double prevCutoffAmount = 0.0;
		double prevRate = 0.0;
		double totalTax = 0.0;
		for(TaxBracketEntry *taxBracketEntry in self.taxBracketEntries)
		{
			double unadjustedCutoffAmount = [taxBracketEntry.cutoffAmount doubleValue];			
			double cutoffAmountMultiplier = [SimInputHelper 
				multiScenVariableRateMultiplier:self.taxBracket.cutoffGrowthRate.growthRate
				sinceStartDate:simParams.simStartDate 
				asOfDate:currentDate andScenario:simParams.simScenario];

			double currCutoffAmount = unadjustedCutoffAmount * cutoffAmountMultiplier;
			
			assert(currCutoffAmount >= prevCutoffAmount);
			double currRate = [taxBracketEntry.taxPercent doubleValue]/100.0;
			assert(currRate >= 0.0);
			assert(currRate <= 1.0);
			
			double amountTaxableUnderPrevRate = MIN(taxableIncome-prevCutoffAmount, 
						currCutoffAmount-prevCutoffAmount);
			assert(amountTaxableUnderPrevRate >= 0.0);
			totalTax += amountTaxableUnderPrevRate * prevRate;
			
			if(taxableIncome <= currCutoffAmount)
			{
				// no need to continue, all the tax revenue is covered under the previous
				// cutoff.
				
				if(creditAmount >= totalTax)
				{
					return 0.0;
				}
				else
				{
					return (totalTax - creditAmount)/grossIncome;
				}

			}
			
			prevCutoffAmount = currCutoffAmount;
			prevRate = currRate;
		}
		// If we make it here, then there's still some taxable income within the top bracket.
		double amountTaxableUnderTopBracket = taxableIncome - prevCutoffAmount;
		assert(amountTaxableUnderTopBracket >= 0.0);
		totalTax += amountTaxableUnderTopBracket * prevRate;
		
		if(creditAmount >= totalTax)
		{
			return 0.0;
		}
		else
		{
			return (totalTax - creditAmount)/grossIncome;
		}
		
	}
}

-(void)dealloc
{
	[taxBracketEntries release];
	[taxBracket release];
	[super dealloc];
}

@end
