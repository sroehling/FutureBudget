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

-(id)init
{
	self = [super init];
	if(self)
	{
		self.taxInputCalcs = [[[NSMutableArray alloc] init] autorelease];
	}
	return self;
}

-(void)addTaxInputCalc:(TaxInputCalc*)theTaxInputCalc
{
	assert(theTaxInputCalc != nil);
	[self.taxInputCalcs addObject:theTaxInputCalc];
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
	[super dealloc];
	[taxInputCalcs release];
}

@end
