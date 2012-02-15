//
//  ItemizedTaxCalcEntries.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxCalcEntries.h"
#import "SimParams.h"
#import "ItemizedTaxAmts.h"
#import "ItemizedTaxAmt.h"
#import "ItemizedTaxCalcPopulator.h"
#import "ItemizedTaxCalcEntry.h"
#import "DateHelper.h"

@implementation ItemizedTaxCalcEntries

@synthesize calcEntries;


-(id)initWithSimParams:(SimParams*)simParams andItemizedTaxAmts:(ItemizedTaxAmts*)itemizedTaxAmts
{
	self = [super init];
	if(self)
	{
		self.calcEntries = [[[NSMutableArray alloc] init] autorelease];
		
		ItemizedTaxCalcPopulator *taxCalcPopulator = 
			[[[ItemizedTaxCalcPopulator alloc] initWithSimParams:simParams] autorelease];
		for(ItemizedTaxAmt *itemizedTaxAmt in itemizedTaxAmts.itemizedAmts)
		{
			assert(itemizedTaxAmt != nil);
			if([itemizedTaxAmt itemIsEnabledForScenario:simParams.simScenario])
			{
				// Only populate the tax calculation if the itemizedTaxAmt is enabled. If could be marked
				// as disabled if it was initially created and enabled, but then subsequently disabled 
				// in the check-list used to setup itemizations.
			
				ItemizedTaxCalcEntry *taxCalcEntry = 
					[taxCalcPopulator populateItemizedTaxCalc:itemizedTaxAmt fromSimParams:simParams];
				assert(taxCalcEntry != nil);
			
				[self.calcEntries addObject:taxCalcEntry];
			}
		}
			
	}
	return self;
}

-(double)calcTotalYearlyItemizedAmt
{
	double totalAmt = 0.0;
	
	for(ItemizedTaxCalcEntry *calcEntry in self.calcEntries)
	{
		assert(calcEntry != nil);
		double itemizedAmt = [calcEntry calcYearlyItemizedAmt];
		assert(itemizedAmt >= 0.0);
		totalAmt += itemizedAmt;
	}
	return totalAmt;
}

-(double)dailyItemizedAmnt:(NSInteger)dayIndex
{
	assert(dayIndex >= 0);
	assert(dayIndex < MAX_DAYS_IN_YEAR);

	double totalAmt = 0.0;
	
	for(ItemizedTaxCalcEntry *calcEntry in self.calcEntries)
	{
		assert(calcEntry != nil);
		double itemizedAmt = [calcEntry dailyItemizedAmt:dayIndex];
		assert(itemizedAmt >= 0.0);
		totalAmt += itemizedAmt;
	}
	return totalAmt;

}

-(void)dealloc
{
	[calcEntries release];
	[super dealloc];
}

@end
