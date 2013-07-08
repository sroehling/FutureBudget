//
//  TaxBracket.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxBracket.h"
#import "MultiScenarioGrowthRate.h"
#import "TaxBracketEntry.h"
#import "LocalizationHelper.h"
#import "NumberHelper.h"
#import "CollectionHelper.h"
#import "Scenario.h"
#import "SimInputHelper.h"

NSString * const TAX_BRACKET_ENTITY_NAME = @"TaxBracket";

@implementation TaxBracket
@dynamic cutoffGrowthRate;
@dynamic taxBracketEntries;

// Inverse Relationship

// TBD - Do we need shared TaxBrackets? The inverse relationship below is setup such that 
// the tax bracket is ownded by the TaxInput, and is deleted with the TaxInput. We need
// to reconsider if tax brackets can be shared amongst TaxInputs, or we support instantiation
// of common tax brackets, or something else.

@dynamic taxInputTaxBracket;


- (void)addTaxBracketEntriesObject:(TaxBracketEntry *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"taxBracketEntries"] addObject:value];
    [self didChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTaxBracketEntriesObject:(TaxBracketEntry *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"taxBracketEntries"] removeObject:value];
    [self didChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTaxBracketEntries:(NSSet *)value {    
    [self willChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"taxBracketEntries"] unionSet:value];
    [self didChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTaxBracketEntries:(NSSet *)value {
    [self willChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"taxBracketEntries"] minusSet:value];
    [self didChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (NSString*)taxBracketSummaryForScenario:(Scenario*)scenario andDate:(NSDate*)dateForRates
{

	if(self.taxBracketEntries.count == 0)
	{
		return LOCALIZED_STR(@"INPUT_TAX_BRACKET_NO_ENTRIES_SUMMARY");
	}
	else if(self.taxBracketEntries.count == 1)
	{
		TaxBracketEntry *singleEntry = [[self.taxBracketEntries allObjects] lastObject];
		assert(singleEntry != nil);


		double rateAsOfSimStartDate = [SimInputHelper multiScenValueAsOfDate:singleEntry.taxPercent.growthRate
											andDate:dateForRates andScenario:scenario];
		NSNumber *storedTaxPerc = [NSNumber numberWithDouble:rateAsOfSimStartDate];
		
		NSString *taxPercDisp  =[[NumberHelper theHelper]
			displayStrFromStoredVal:storedTaxPerc
			andFormatter:[NumberHelper theHelper].percentFormatter];

		if([singleEntry.cutoffAmount doubleValue] <= 0.0)
		{
			NSString *flatTaxSummary = [NSString stringWithFormat:
				LOCALIZED_STR(@"INPUT_TAX_BRACKET_SINGLE_RATE_SUMMARY_FORMAT"),
				taxPercDisp];
			return flatTaxSummary;
		}
		else
		{
			NSString *initialPercentSummary = [[NumberHelper theHelper]
				displayStrFromStoredVal:[NSNumber numberWithDouble:0.0]
				andFormatter:[NumberHelper theHelper].percentFormatter];
							
			NSString *amountSummary = [[NumberHelper theHelper]
				displayStrFromStoredVal:singleEntry.cutoffAmount
				andFormatter:[NumberHelper theHelper].currencyFormatter];
				
			rateAsOfSimStartDate = [SimInputHelper multiScenValueAsOfDate:singleEntry.taxPercent.growthRate
									andDate:dateForRates andScenario:scenario];	
			NSNumber *storedTaxPerc = [NSNumber numberWithDouble:rateAsOfSimStartDate];
			NSString *percentSummary = [[NumberHelper theHelper]
				displayStrFromStoredVal:storedTaxPerc
				andFormatter:[NumberHelper theHelper].percentFormatter];
				
			NSString *singleBracketSummary = [NSString stringWithFormat:
				LOCALIZED_STR(@"INPUT_TAX_BRACKET_SINGLE_BRACKET_SUMMARY_FORMAT"),
				initialPercentSummary,amountSummary,percentSummary,amountSummary];
		
			return singleBracketSummary;
			
		}
	}
	else
	{
		NSMutableArray *allTaxBracketEntries = [NSMutableArray arrayWithArray:
			[CollectionHelper setToSortedArray:self.taxBracketEntries
				withKey:TAX_BRACKET_ENTRY_CUTOFF_AMOUNT_KEY]];
			
		NSMutableArray *taxBracketSummaries = [[[NSMutableArray alloc] init] autorelease];
			
		TaxBracketEntry *firstEntry = [allTaxBracketEntries objectAtIndex:0];
		assert(firstEntry != nil);
		NSString *initialPercentSummary;
		NSString *initialAmountSummary;
		if([firstEntry.cutoffAmount doubleValue]>0.0)
		{
			// If the cutoff amount for the first entry is > $0, then
			// anything less than (up to) that amount is taxed at 0%. 
			initialPercentSummary = [[NumberHelper theHelper]
				displayStrFromStoredVal:[NSNumber numberWithDouble:0.0]
				andFormatter:[NumberHelper theHelper].percentFormatter];
			initialAmountSummary = [[NumberHelper theHelper]
				displayStrFromStoredVal:firstEntry.cutoffAmount
				andFormatter:[NumberHelper theHelper].currencyFormatter];
		}
		else
		{
			// If the cutoff amount is $0, then anything up until the
			// 2nd tax bracket entry's cutoff amount is taxed at the given percent.

			[allTaxBracketEntries removeObjectAtIndex:0];
			TaxBracketEntry *secondEntry = [allTaxBracketEntries objectAtIndex:0];
			assert(secondEntry != nil);

			double rateAsOfSimStartDate = [SimInputHelper multiScenValueAsOfDate:firstEntry.taxPercent.growthRate
												andDate:dateForRates andScenario:scenario];
			NSNumber *storedTaxPerc = [NSNumber numberWithDouble:rateAsOfSimStartDate];
			initialPercentSummary = [[NumberHelper theHelper]
				displayStrFromStoredVal:storedTaxPerc
				andFormatter:[NumberHelper theHelper].percentFormatter];
			initialAmountSummary = [[NumberHelper theHelper]
				displayStrFromStoredVal:secondEntry.cutoffAmount
				andFormatter:[NumberHelper theHelper].currencyFormatter];
			
			
		}
		
		NSString *initialSummary = [NSString stringWithFormat:LOCALIZED_STR(@"INPUT_TAX_BRACKET_SINGLE_BRACKET_INITIAL_BRACKET_FORMAT"),
			initialPercentSummary,initialAmountSummary];
		[taxBracketSummaries addObject:initialSummary];
		
				
		// Concatenate together summaries of the remaining tax bracket entries.
		for(TaxBracketEntry *taxBracketEntry in allTaxBracketEntries)
		{
			double rateAsOfSimStartDate = [SimInputHelper multiScenValueAsOfDate:taxBracketEntry.taxPercent.growthRate
													andDate:dateForRates andScenario:scenario];
			NSNumber *storedTaxPerc = [NSNumber numberWithDouble:rateAsOfSimStartDate];
			NSString *percentSummary = [[NumberHelper theHelper]
				displayStrFromStoredVal:storedTaxPerc
				andFormatter:[NumberHelper theHelper].percentFormatter];
			NSString *amountSummary = [[NumberHelper theHelper]
				displayStrFromStoredVal:taxBracketEntry.cutoffAmount
				andFormatter:[NumberHelper theHelper].currencyFormatter];
			NSString *entrySummary = [NSString stringWithFormat:LOCALIZED_STR(@"INPUT_TAX_BRACKET_SINGLE_BRACKET_ABOVE_AMOUNT_BRACKET_FORMAT"),
				percentSummary,amountSummary];
			[taxBracketSummaries addObject:entrySummary];
		}
		
		NSString *combinedSummary = [taxBracketSummaries componentsJoinedByString:@", "];
		return combinedSummary;
	}
	return @"";
}

@end
