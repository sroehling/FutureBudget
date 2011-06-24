//
//  VariableRateCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableRateCalculator.h"
#import "CollectionHelper.h"
#import "VariableRate.h"


@implementation VariableRateCalculator

@synthesize variableRates;

- (id)initWithRates:(NSMutableSet*)rates
{
	self = [super init];
	if(self)
	{
		assert(rates != nil);
		self.variableRates = [CollectionHelper setToSortedArray:rates withKey:@"daysSinceStart"];
		assert([self.variableRates count] > 0); // must be at least one rate
		VariableRate *firstRate = (VariableRate*)[self.variableRates objectAtIndex:0];
		assert(firstRate.daysSinceStart == 0); // first rate must start on first day.
	}
	return self;
}

- (id) init 
{
	assert(0); // must call init above.
	return nil;
}

- (double) valueMultiplierForDay:(unsigned int)daysOffsetFromStart
{
	
	double valueMultiplier = 1.0;

	unsigned int currOffset = 0;
	NSUInteger currRateIndex = 0;
	assert([self.variableRates count] > 0);
	VariableRate *currRate = (VariableRate*)[self.variableRates objectAtIndex:currRateIndex];
	while(currOffset < daysOffsetFromStart)
	{
		unsigned int daysAtCurrentRate;
		if((currRateIndex + 1) == [self.variableRates count])
		{
			// This is the last index (rate change) => 
			// all the remaining days fall under the current rate.
			 daysAtCurrentRate = daysOffsetFromStart - currOffset;
			 currOffset = daysOffsetFromStart;
		}
		else
		{
			// This is not the last rate change
			
			VariableRate *nextRate = (VariableRate*)[self.variableRates objectAtIndex:(currRateIndex+1)];
			assert(nextRate.daysSinceStart >= currRate.daysSinceStart);
			if(nextRate.daysSinceStart > daysOffsetFromStart)
			{
				// The next rate is beyond the end date being requested => 
				// all the remaining days fall under the current rate.
				daysAtCurrentRate = daysOffsetFromStart - currOffset;
				currOffset = daysOffsetFromStart;		
			}
			else
			{
				daysAtCurrentRate = nextRate.daysSinceStart - currOffset;
				currOffset = nextRate.daysSinceStart;
			}
			currRate = nextRate;
		}
		currRateIndex++;
		// Compund the multiplier using the current daily rate and the number
		// of days to compound at the current rate.
		valueMultiplier = valueMultiplier * pow(currRate.dailyRate + 1.0,daysAtCurrentRate);
		
	}
	return valueMultiplier;
}

- (void) dealloc
{
	[super dealloc];
	[variableRates release];
}

@end
