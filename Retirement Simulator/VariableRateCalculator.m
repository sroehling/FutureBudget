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
@synthesize dateHelper;

- (void) dealloc
{
	[variableRates release];
	[startDate release];
    [dateHelper release];
	[super dealloc];
}

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
        
        self.dateHelper = [[[DateHelper alloc] init] autorelease];
	}
	return self;
}

- (id)initWithSingleAnnualRate:(double)theRate andStartDate:(NSDate*)theStart
{
	NSMutableSet *varRates = [[[NSMutableSet alloc] init] autorelease];
	VariableRate *varRate = [[[VariableRate alloc]
		initWithAnnualRate:theRate andDaysSinceStart:0] autorelease];
	[varRates addObject:varRate];
	
	return [self initWithRates:varRates andStartDate:theStart];
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
		
		// If the start date for value changes is later than the 
		// given date, we return a value of 1.0, meaning the 
		// value is unchanged.
		if([self.dateHelper dateIsLater:self.startDate otherDate:theDate])
		{
			return 1.0;
		}

		NSInteger daysSinceStart = [self.dateHelper daysOffset:theDate vsEarlierDate:self.startDate];
		double amountMultiplier = [self valueMultiplierForDay:daysSinceStart];
		assert(amountMultiplier >= 0.0);
		return amountMultiplier;
}

- (double)valueMultiplierBetweenStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate
{
	assert(theStartDate!=nil);
	assert(theEndDate!=nil);
	assert([self.dateHelper dateIsEqualOrLater:theEndDate otherDate:theStartDate]);
	
	
	// There are 3 basic variations of where self.startDate can be in relation to
	// theStartDate and theEndDate. The logic of this selector depends on which 
	// variation.
	// 
	// V1: (self.startDate,theStartDate,theEndDate): multiplier starts at
	//    theStartDate).
	// V2: (theStartDate,self.startDate,theEndDate): multiplier calculated starting
	//     at self.startDate.
	// V3: (theStartDate,theEndDate,self.startDate): default to 1.0,
	//     since self.startDate beginsafter theEndDate.

	// V3 (see above): If the start date for rate calculation is later than the 
	// given end date, we return a value of 1.0, meaning the 
	// value is unchanged because the rate multiplier does not change 
	// before the start date.
	if([self.dateHelper dateIsLater:self.startDate otherDate:theEndDate])
	{
		return 1.0;
	} 
	
	// If self.startDate is after the given start date, we use it as a basis
	// for computing the multiplier instead of theStartDate. This could happen
	// in cases where an input such as a loan has an origination date which starts
	// after the theStartDate, or an asset which has a purchase date in the future. 
	NSDate *multiplierStartDate;
	if([self.dateHelper dateIsEqualOrLater:theStartDate otherDate:self.startDate])
	{
		// V1 (see above)
		multiplierStartDate = theStartDate;
	}
	else
	{
		// V2 (see above)
		multiplierStartDate = self.startDate;
	}	
	
	double startDateMultiplier = [self valueMultiplierForDate:multiplierStartDate];
	double endDateMultiplier = [self valueMultiplierForDate:theEndDate];
	assert(startDateMultiplier > 0.0);
	assert(endDateMultiplier > 0.0);
	
	double multiplierBetweenDates = endDateMultiplier/startDateMultiplier;
	return multiplierBetweenDates;
} 

-(NSUInteger)daysSinceStart:(NSDate*)timeAfterStart
{
    assert([self.dateHelper dateIsEqualOrLater:timeAfterStart otherDate:self.startDate]);
    NSTimeInterval secondsVsStart = [timeAfterStart timeIntervalSinceDate:self.startDate];
    NSUInteger daysVsStart = floor(secondsVsStart/SECONDS_PER_DAY);
    return daysVsStart;
}


- (VariableRateCalculator*)intersectWithVarRateCalc:(VariableRateCalculator*)otherVarRateCalc
                                    usingCutoffDate:(NSDate*)cutoffDateOtherRateCalc
{
    // This method is constrained to work with calculator with equal start dates.
    assert([self.dateHelper dateIsEqual:self.startDate otherDate:otherVarRateCalc.startDate]);
    
    assert(cutoffDateOtherRateCalc != nil);
    
    if([self.dateHelper dateIsEqualOrLater:self.startDate otherDate:cutoffDateOtherRateCalc])
    {
        // The cutoff date is before the start date. In this case, the rate calculations from
        // otherVarRateCalc are always used.
        return otherVarRateCalc;
    }
    else
    {
        // The cutoff date is after the start date.
        
        NSUInteger cutoffDaysSinceStart = [self daysSinceStart:cutoffDateOtherRateCalc];
        
        NSMutableSet *intersectRates = [[[NSMutableSet alloc] init] autorelease];
  
        assert(self.variableRates.count > 0);
        
        // (1) All the VariableValue objects *before* the cutoff date are taken from self, including
        //     the starting value.
        NSUInteger selfVarRateIndex = 0;
        VariableRate *selfVarRate = (VariableRate*)[self.variableRates objectAtIndex:selfVarRateIndex];
        assert(selfVarRate != nil);
        
        for(VariableRate *selfVarRate in self.variableRates)
        {
            if(selfVarRate.daysSinceStart < cutoffDaysSinceStart)
            {
                [intersectRates addObject:selfVarRate];
            }
        }
        
        
        // (2) The most recent (last) value before the cutoff date in otherVarRateCalc is inserted
        //     as the new rate as of the cutoff date. In other words, step back through the array
        //     to find the first VariableRate whose daysSinceStart property is less than or equal to
        //     the cutoff date, then create rateAsOfCutoff to set the rate for the cutoff date.
        NSUInteger otherVarRateIndex = otherVarRateCalc.variableRates.count-1;
        assert(otherVarRateCalc.variableRates.count > 0);
        VariableRate *otherVarRate = (VariableRate*)[otherVarRateCalc.variableRates objectAtIndex:otherVarRateIndex];
        assert(otherVarRate != nil);
        while((otherVarRate.daysSinceStart > cutoffDaysSinceStart) &&
              (otherVarRateIndex > 0))
        {
            otherVarRateIndex --;
            otherVarRate = (VariableRate*)[otherVarRateCalc.variableRates objectAtIndex:otherVarRateIndex];
            assert(otherVarRate != nil);
        }
        assert(otherVarRate.daysSinceStart <= cutoffDaysSinceStart);
        VariableRate *rateAsOfCutoff = [[[VariableRate alloc]
            initWithDailyRate:otherVarRate.dailyRate andDaysSinceStart:cutoffDaysSinceStart]autorelease];
        [intersectRates addObject:rateAsOfCutoff];
        
        
        // (3) Any remaining values changes in otherVarRateCalc are inserted after the cutoff date.
        otherVarRateIndex++;
        while(otherVarRateIndex < otherVarRateCalc.variableRates.count)
        {
            otherVarRate = (VariableRate*)[otherVarRateCalc.variableRates objectAtIndex:otherVarRateIndex];
            assert(otherVarRate != nil);
            assert(otherVarRate.daysSinceStart > cutoffDaysSinceStart);
            [intersectRates addObject:otherVarRate];
            otherVarRateIndex++;
        }
        
        return [[[VariableRateCalculator alloc] initWithRates:intersectRates
                    andStartDate:self.startDate] autorelease];
     }
    
    
    
}


@end
