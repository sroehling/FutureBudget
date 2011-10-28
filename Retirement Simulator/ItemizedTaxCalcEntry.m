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
	return self.applicableTaxPerc * digestSum.yearlyTotal;
}

-(double)dailyItemizedAmt:(NSInteger)dayIndex
{
	assert(dayIndex >= 0);
	assert(dayIndex < MAX_DAYS_IN_YEAR);
	return self.applicableTaxPerc * [self.digestSum dailySum:dayIndex]; 
}

-(void)dealloc
{
	[super dealloc];
	[digestSum release];
}

@end
