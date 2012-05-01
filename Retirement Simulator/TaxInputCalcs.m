//
//  TaxInputCalcCltn.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxInputCalcs.h"
#import "TaxInputCalc.h"


@implementation TaxInputCalcs

@synthesize taxInputCalcs;
@synthesize taxesSimulated;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.taxInputCalcs = [[[NSMutableArray alloc] init] autorelease];
		self.taxesSimulated = [[[NSMutableSet alloc] init] autorelease];
	}
	return self;
}

-(void)configCalcEntries:(SimParams*)theSimParams
{
	for(TaxInputCalc *taxInputCalc in self.taxInputCalcs)
	{
		[taxInputCalc configTaxCalcEntries:theSimParams];
	}

}

-(void)addTaxInputCalc:(TaxInputCalc*)theTaxInputCalc
{
	assert(theTaxInputCalc != nil);
	[self.taxInputCalcs addObject:theTaxInputCalc];
	assert(theTaxInputCalc.taxInput != nil);
	[self.taxesSimulated addObject:theTaxInputCalc.taxInput];
}

-(void)updateEffectiveTaxRates:(NSDate*)currentDate
{
	assert(currentDate != nil);
	for(TaxInputCalc *taxInputCalc in self.taxInputCalcs)
	{
		[taxInputCalc updateEffectiveTaxRate:currentDate];
	}
}

-(void)processDailyTaxPmts:(DigestEntryProcessingParams*)processingParams
{
	for(TaxInputCalc *taxInputCalc in self.taxInputCalcs)
	{
		[taxInputCalc processDailyTaxPmt:processingParams];
	}
}

-(void)dealloc
{
	[taxInputCalcs release];
	[taxesSimulated release];
	[super dealloc];
}

@end
