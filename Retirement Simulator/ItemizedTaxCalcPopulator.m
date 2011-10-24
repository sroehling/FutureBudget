//
//  ItemizedTaxCalcPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxCalcPopulator.h"

#import "ItemizedTaxAmt.h"
#import "IncomeItemizedTaxAmt.h"
#import "IncomeSimInfo.h"
#import "SimParams.h"
#import "InputSimInfoCltn.h"
#import "IncomeInput.h"
#import "ItemizedTaxAmt.h"
#import "ItemizedTaxCalcEntry.h"
#import "SimInputHelper.h"


@implementation ItemizedTaxCalcPopulator

@synthesize simParams;
@synthesize calcEntry;

-(double)resolveTaxablePercent:(ItemizedTaxAmt*)itemizedTaxAmt
{
	double applicableTaxablePerc = 
		[SimInputHelper multiScenFixedVal:itemizedTaxAmt.multiScenarioApplicablePercent 
		andScenario:self.simParams.simScenario];
	assert(applicableTaxablePerc >= 0.0);
	assert(applicableTaxablePerc <= 100.0);
	applicableTaxablePerc = applicableTaxablePerc / 100.0;
	return applicableTaxablePerc;
	
}

-(void)visitIncomeItemizedTaxAmt:(IncomeItemizedTaxAmt*)itemizedTaxAmt
{
	IncomeSimInfo *simInfo = [self.simParams.incomeInfo getSimInfo:itemizedTaxAmt.income];
	double taxPerc = [self resolveTaxablePercent:itemizedTaxAmt];
	
	self.calcEntry = [[[ItemizedTaxCalcEntry alloc] initWithTaxPerc:taxPerc andDigestSum:simInfo.digestSum] autorelease];
	
}

-(id)initWithSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theSimParams != nil);
		self.simParams = theSimParams;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(ItemizedTaxCalcEntry*)populateItemizedTaxCalc:(ItemizedTaxAmt*)itemizedTaxAmt 
	fromSimParams:(SimParams*)theSimParams
{
	self.calcEntry = nil;
	[itemizedTaxAmt acceptVisitor:self];
	assert(self.calcEntry != nil);
	return self.calcEntry;
}

-(void)dealloc
{
	[super dealloc];
	[simParams release];
	[calcEntry release];
}

@end
