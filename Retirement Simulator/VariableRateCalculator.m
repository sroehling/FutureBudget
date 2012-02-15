//
//  VariableRateCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableRateCalculator.h"
#import "CollectionHelper.h"
#import "DateHelper.h"
#import "VariableRate.h"


@implementation VariableRateCalculator

@synthesize variableRates;
@synthesize startDate;

- (id)initWithRates:(NSMutableSet*)rates andStartDate:(NSDate *)theStart
{
	self = [super init];
	if(self)
	{
		assert(rates != nil);
		self.variableRates = [CollectionHelper setToSortedArray:rates withKey:@"daysSinceStart"];
		assert([self.variableRates count] > 0); // must be at least one rate
		VariableRate *firstRate = (VariableRate*)[self.variableRates objectAtIndex:0];
		assert(firstRate.daysSinceStart == 0); // first rate must start on first day.
		
		assert(theStart != nil);
		self.startDate = theStart;
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
		if((currRateIndex + 1) >= [self.variableRates count])
		{
			// This is the last index (rate change) => 
			// all the remaining days fall under the current rate.
			 daysAtCurrentRate = daysOffsetFromStart - currOffset;
			 valueMultiplier = valueMultiplier * pow(currRate.dailyRate + 1.0,daysAtCurrentRate);
			 return valueMultiplier;
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
				valueMultiplier = valueMultiplier * pow(currRate.dailyRate + 1.0,daysAtCurrentRate);
				return valueMultiplier;
			}
			else
			{
				// The next rate doesn't extend beyond the date being requested. 
				// So, calculate the number of days, daysAtCurrentRate, until the 
				// next rate goes into effect then calculate the rate multiplier under
				// the current rate for this number of days.
				if(nextRate.daysSinceStart > currOffset)
				{
					daysAtCurrentRate = nextRate.daysSinceStart - currOffset;
					assert(daysAtCurrentRate >= 1);
					currOffset = nextRate.daysSinceStart;
					valueMultiplier = valueMultiplier * pow(currRate.dailyRate + 1.0,daysAtCurrentRate);					
				}
				currRate = nextRate;
			}
		}
		currRateIndex++;
	}
	return valueMultiplier;
}

- (double)valueMultiplierForDate:(NSDate*)theDate
{
		assert(theDate != nil);
		assert([DateHelper dateIsEqualOrLater:theDate otherDate:self.startDate]);
		NSInteger daysSinceStart = [DateHelper daysOffset:theDate vsEarlierDate:self.startDate];
		double amountMultiplier = [self valueMultiplierForDay:daysSinceStart];
		assert(amountMultiplier >= 0.0);
		return amountMultiplier;
}

- (double)valueMultiplierBetweenStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate
{
	assert(theStartDate!=nil);
	assert(theEndDate!=nil);
	assert([DateHelper dateIsEqualOrLater:theStartDate otherDate:self.startDate]);
	assert([DateHelper dateIsEqualOrLater:theEndDate otherDate:self.startDate]);
	assert([DateHelper dateIsEqualOrLater:theEndDate otherDate:theStartDate]);
	
	double startDateMultiplier = [self valueMultiplierForDate:theStartDate];
	double endDateMultiplier = [self valueMultiplierForDate:theEndDate];
	assert(startDateMultiplier > 0.0);
	assert(endDateMultiplier > 0.0);
	
	double multiplierBetweenDates = endDateMultiplier/startDateMultiplier;
	return multiplierBetweenDates;
} 


- (void) dealloc
{
	[variableRates release];
	[startDate release];
	[super dealloc];
}

@end
