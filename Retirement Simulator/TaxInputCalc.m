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
#import "IncomeSimInfo.h"

@implementation TaxInputCalc

@synthesize taxInput;
@synthesize incomeCalcEntries;

-(id)initWithTaxInput:(TaxInput*)theTaxInput andSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theTaxInput != nil);
		self.taxInput = theTaxInput;
		
		self.incomeCalcEntries = [[[ItemizedTaxCalcEntries alloc] initWithSimParams:theSimParams andItemizedTaxAmts:self.taxInput.itemizedIncomeSources] autorelease];
		
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[taxInput release];
	[incomeCalcEntries release];
}

@end
