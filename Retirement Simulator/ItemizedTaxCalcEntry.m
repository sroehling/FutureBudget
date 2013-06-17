//
//  ItemizedTaxCalcEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxCalcEntry.h"
#import "InputValDigestSummation.h"
#import "DateHelper.h"


@implementation ItemizedTaxCalcEntry

@synthesize digestSum;
@synthesize applicableTaxPerc;
@synthesize zeroOutNegativeVals;
@synthesize invertVals;

-(id)initWithTaxPerc:(double)taxPerc andDigestSum:(InputValDigestSummation*)theSum
{
	self = [super init];
	if(self)
	{
		assert(taxPerc >= 0.0);
		assert(taxPerc <= 1.0);
		assert(theSum != nil);
		
		self.digestSum = theSum;
		self.applicableTaxPerc = taxPerc;
		
		zeroOutNegativeVals = FALSE;
		invertVals = FALSE;
		
	}
	return self;
}

-(id)init
{
	assert(0); // must init with tax percent and digest sum
	return nil;
}

-(double)calcYearlyItemizedAmt
{

	double yearlyTotal = digestSum.yearlyTotal;
	
	if(self.invertVals)
	{
		yearlyTotal *= -1.0;
	}


	if(self.zeroOutNegativeVals && (yearlyTotal < 0.0))
	{
		yearlyTotal = 0.0;
	}

	return self.applicableTaxPerc * yearlyTotal;
}

-(double)dailyItemizedAmt:(NSInteger)dayIndex
{
	assert(dayIndex >= 0);
	assert(dayIndex < MAX_DAYS_IN_YEAR);
	
	double dailySum = [self.digestSum dailySum:dayIndex];
	
	if(self.invertVals)
	{
		dailySum *= -1.0;
	}
	
	if(self.zeroOutNegativeVals && (dailySum < 0.0))
	{
		dailySum = 0.0;
	}
	
	return self.applicableTaxPerc * dailySum; 
}

-(void)dealloc
{
	[digestSum release];
	[super dealloc];
}

@end
