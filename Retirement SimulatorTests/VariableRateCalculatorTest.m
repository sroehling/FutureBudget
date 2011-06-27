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
#import "InMemoryCoreData.h"
#import "TestDateHelper.h"

#import "FixedValue.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "VariableValue.h"
#import "DateSensitiveValueChange.h"

#import "FixedDate.h"
#import "DateHelper.h"
#import "TestCoreDataObjects.h"

@implementation VariableRateCalculatorTest

@synthesize coreData;

- (void)setUp
{
	self.coreData = [[[InMemoryCoreData alloc] init] autorelease];
}

- (void)tearDown
{
	[coreData release];
}




- (void)checkOneRateCalc:(VariableRateCalculator*)rateCalc 
	andDaysSinceStart:(unsigned int)daysSinceStart andExpectedVal:(double)expectedVal
{
	NSString *expectedStr = [NSString stringWithFormat:@"%0.2f",expectedVal];
	double valueMult = [rateCalc valueMultiplierForDay:daysSinceStart];
	NSString *valueMultStr = [NSString stringWithFormat:@"%0.2f",valueMult];
	STAssertEqualObjects(expectedStr, valueMultStr, 
				   @"Values expected to be equal: expecting %@, got %@", expectedStr,valueMultStr);
	NSLog(@"checkOneRateCalc: Expecting %@, got %@ for days since start of %d",
		  expectedStr,valueMultStr,daysSinceStart);
}

- (void)testSimpleRateCalc
{
	NSMutableSet *varRates = [[[NSMutableSet alloc] init] autorelease];
	[varRates addObject:[[[VariableRate alloc] initWithDailyRate:0.1 andDaysSinceStart:0]autorelease]];
	
	VariableRateCalculator *rateCalc = [[[VariableRateCalculator alloc] initWithRates:varRates] autorelease];
	
	[self checkOneRateCalc:rateCalc andDaysSinceStart:0 andExpectedVal:1.0];
	[self checkOneRateCalc:rateCalc andDaysSinceStart:5 andExpectedVal:1.61];
	//NSLog(@"Multiplier on day 0: %f",[rateCalc valueMultiplierForDay:0]);

}


- (void)testMultipleRateCalc
{
	NSMutableSet *varRates = [[[NSMutableSet alloc] init] autorelease];
	// Note that the objects are added out of order, which also checks that the VariableRateCalcular
	// properly sorts the rates by the days since starting before they are used in calculations.
	[varRates addObject:[[[VariableRate alloc] initWithDailyRate:0.1 andDaysSinceStart:0]autorelease]];
	[varRates addObject:[[[VariableRate alloc] initWithDailyRate:0.3 andDaysSinceStart:10]autorelease]];
	[varRates addObject:[[[VariableRate alloc] initWithDailyRate:0.2 andDaysSinceStart:5]autorelease]];
	
	VariableRateCalculator *rateCalc = [[[VariableRateCalculator alloc] initWithRates:varRates] autorelease];
	
	[self checkOneRateCalc:rateCalc andDaysSinceStart:0 andExpectedVal:1.0];
	[self checkOneRateCalc:rateCalc andDaysSinceStart:4 andExpectedVal:1.46];
	[self checkOneRateCalc:rateCalc andDaysSinceStart:5 andExpectedVal:1.61];
	[self checkOneRateCalc:rateCalc andDaysSinceStart:8 andExpectedVal:2.78];
	[self checkOneRateCalc:rateCalc andDaysSinceStart:10 andExpectedVal:4.01];
	[self checkOneRateCalc:rateCalc andDaysSinceStart:11 andExpectedVal:5.21];
	//NSLog(@"Multiplier on day 0: %f",[rateCalc valueMultiplierForDay:0]);
	
}

- (void)testOverlappingRateCalc
{
	NSMutableSet *varRates = [[[NSMutableSet alloc] init] autorelease];
	[varRates addObject:[[[VariableRate alloc] initWithDailyRate:0.1 andDaysSinceStart:0]autorelease]];
	[varRates addObject:[[[VariableRate alloc] initWithDailyRate:0.1 andDaysSinceStart:5]autorelease]];
	[varRates addObject:[[[VariableRate alloc] initWithDailyRate:0.1 andDaysSinceStart:5]autorelease]];
	
	VariableRateCalculator *rateCalc = [[[VariableRateCalculator alloc] initWithRates:varRates] autorelease];

	[self checkOneRateCalc:rateCalc andDaysSinceStart:5 andExpectedVal:1.61];
	[self checkOneRateCalc:rateCalc andDaysSinceStart:6 andExpectedVal:1.77];
	
}


- (void)testVariableRateCalcWithDSV
{	
	FixedValue *fixedVal = (FixedValue*)[self.coreData createObj:FIXED_VALUE_ENTITY_NAME];
	fixedVal.value = [NSNumber numberWithDouble:1.2];
	
	VariableValue *variableVal = (VariableValue*)[self.coreData createObj:VARIABLE_VALUE_ENTITY_NAME];
	variableVal.startingValue = [NSNumber numberWithDouble:10.0];
	variableVal.name = @"Test";
	[variableVal addValueChangesObject:[TestCoreDataObjects 
				createTestValueChange:self.coreData andDate:@"2012-01-01" andVal:10.0]];
	[variableVal addValueChangesObject:[TestCoreDataObjects
				createTestValueChange:self.coreData andDate:@"2013-01-01" andVal:10.0]];

	DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		[[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];
	VariableRateCalculator *varRateCalc = 
		[calcCreator createForDateSensitiveValue:variableVal andStartDate:[TestDateHelper dateFromStr:@"2011-01-01"]];
	[self checkOneRateCalc:varRateCalc andDaysSinceStart:0 andExpectedVal:1.0];
	[self checkOneRateCalc:varRateCalc andDaysSinceStart:365 andExpectedVal:1.1];
	[self checkOneRateCalc:varRateCalc andDaysSinceStart:730 andExpectedVal:1.21];
	[self checkOneRateCalc:varRateCalc andDaysSinceStart:1095 andExpectedVal:1.33];
	
	

}

@end
