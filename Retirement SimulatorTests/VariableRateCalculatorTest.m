//
//  VariableRateCalculatorTest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableRateCalculatorTest.h"

#import "VariableRateCalculator.h"
#import "VariableRate.h"


@implementation VariableRateCalculatorTest

- (void)testVariableRateCalc
{
	STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
	
	NSMutableSet *varRates = [[[NSMutableSet alloc] init] autorelease];
	[varRates addObject:[[[VariableRate alloc] initWithDailyRate:0.1 andDaysSinceStart:0]autorelease]];

	VariableRateCalculator *rateCalc = [[[VariableRateCalculator alloc] initWithRates:varRates] autorelease];
	NSLog(@"Multiplier on day 0: %f",[rateCalc valueMultiplierForDay:0]);
}

@end
