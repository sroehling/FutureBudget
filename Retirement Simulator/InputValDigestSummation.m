//
//  InputSummation.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputValDigestSummation.h"
#import "DateHelper.h"

@implementation InputValDigestSummation

-(id)init
{
	self = [super init];
	if(self)
	{
		currentSum = malloc(sizeof(double) * MAX_DAYS_IN_YEAR);
		if(currentSum == NULL)
		{
			return nil;
		}
		else
		{
			[self resetSum];
		}
	}
	return self;
}

-(void)incrementSum:(double)amount onDay:(NSInteger)dayIndex
{
	assert(amount >= 0.0);
	assert(dayIndex >= 0);
	assert(dayIndex < MAX_DAYS_IN_YEAR);
	currentSum[dayIndex] = currentSum[dayIndex] + amount;
}

-(void)resetSum
{
	for(int i = 0; i < MAX_DAYS_IN_YEAR;i++)
	{
		currentSum[i] = 0.0;
	}
}

-(double)yearlyTotal
{
	double total = 0.0;
	for(int i = 0; i < MAX_DAYS_IN_YEAR;i++)
	{
		total += currentSum[i];
	}
	return total;	
}

-(void)dealloc
{
	[super dealloc];
	free(currentSum);
}

@end
