//
//  ValueAsOfCalculatorCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ValueAsOfCalculatorCreator.h"
#import "DateSensitiveValue.h"
#import "FixedValueAsOfCalculator.h"
#import "VariableValueAsOfCalculator.h"


@implementation ValueAsOfCalculatorCreator

@synthesize valueCalc;

- (void)visitFixedValue:(FixedValue*)fixedVal
{
	self.valueCalc = [[[FixedValueAsOfCalculator alloc] initWithFixedValue:fixedVal] autorelease];
}



- (void)visitVariableValue:(VariableValue*)variableVal
{
	self.valueCalc = [[[VariableValueAsOfCalculator alloc] initWithVariableValue:variableVal] autorelease];
}

- (id<ValueAsOfCalculator>) createForDateSensitiveValue:(DateSensitiveValue*)dsVal
{
		self.valueCalc = nil;
		
		[dsVal acceptDateSensitiveValVisitor:self];
		
		assert(self.valueCalc != nil);
		return self.valueCalc;
}

- (void) dealloc
{
	[super dealloc];
	[valueCalc release];
}


@end
