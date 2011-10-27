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
#import "ItemizedTaxCalcPopulator.h"
#import "ItemizedTaxCalcEntry.h"

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
			
			ItemizedTaxCalcEntry *taxCalcEntry = 
				[taxCalcPopulator populateItemizedTaxCalc:itemizedTaxAmt fromSimParams:simParams];
			assert(taxCalcEntry != nil);
			
			[self.calcEntries addObject:taxCalcEntry];
			
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

-(void)dealloc
{
	[super dealloc];
	[calcEntries release];
}

@end
