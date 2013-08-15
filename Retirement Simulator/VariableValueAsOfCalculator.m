//
//  VariableValueAsOfCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueAsOfCalculator.h"
#import "VariableValue.h"
#import "CollectionHelper.h"
#import "DateSensitiveValueChange.h"
#import "SimDate.h"


@implementation VariableValueAsOfCalculator

@synthesize varVal;
@synthesize sortedValChanges;

- (id) initWithVariableValue:(VariableValue*)theVarVal
{
	self = [super init];
	if(self)
	{
		self.varVal = theVarVal;
		self.sortedValChanges = [CollectionHelper setToSortedArray:theVarVal.valueChanges withKey:
								 DATE_SENSITIVE_VALUE_CHANGE_START_DATE_SORT_KEY];
	}
	return self;
}

- (id) init 
{
	assert(0);
	return nil;
}


- (double)valueAsOfDate:(NSDate*)theAsOfDate
{
	NSNumber *currVal = self.varVal.startingValue;
	for(DateSensitiveValueChange *valChange in self.sortedValChanges)
	{
		NSComparisonResult valChangeDateComparedToAsOfDate = 
			[valChange.startDate.date compare:theAsOfDate];

		if((valChangeDateComparedToAsOfDate == NSOrderedAscending) ||
				(valChangeDateComparedToAsOfDate == NSOrderedSame) )
		{		
			// theAsOfDate is after (or the same as) the date on the value change
			// (i.e., the value change happens before theAsOfDate)
			currVal = valChange.valueAfterChange;
		}
		else
		{
			// The date on the value change is after the requested "as of" date,
			// so we can return whatever the current value is.
			return [currVal doubleValue];
		}
	}
	return [currVal doubleValue];
}

- (void) dealloc
{
	[varVal release];
	[sortedValChanges release];
	[super dealloc];
}

@end
