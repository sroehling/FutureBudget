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

#import "FixedValue.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "VariableValue.h"
#import "DateSensitiveValueChange.h"

#import "FixedDate.h"
#import "DateHelper.h"


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

- (NSDate*)dateFromStr:(NSString*)dateStr
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *theDate = [dateFormatter dateFromString:dateStr];
	assert(theDate != nil);
	return theDate;
}

- (DateSensitiveValueChange*)createTestValueChange:(NSString*)dateStr andVal:(double)val
{

	DateSensitiveValueChange *valChange = (DateSensitiveValueChange*)[self.coreData createObj:@"DateSensitiveValueChange"];
		
	FixedDate *fixedStartDate = (FixedDate*) [self.coreData createObj:@"FixedDate"];
	fixedStartDate.date = [self dateFromStr:dateStr];
	
	valChange.startDate = fixedStartDate;
	valChange.newValue = [NSNumber numberWithDouble:val];
	return valChange;
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

- (void)testVariableRateCalc
{
	STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
	
	NSMutableSet *varRates = [[[NSMutableSet alloc] init] autorelease];
	[varRates addObject:[[[VariableRate alloc] initWithDailyRate:0.1 andDaysSinceStart:0]autorelease]];

	VariableRateCalculator *rateCalc = [[[VariableRateCalculator alloc] initWithRates:varRates] autorelease];
//NSLog(@"Multiplier on day 0: %f",[rateCalc valueMultiplierForDay:0]);
	
	
	FixedValue *fixedVal = (FixedValue*)[self.coreData createObj:@"FixedValue"];
	fixedVal.value = [NSNumber numberWithDouble:1.2];
	
	VariableValue *variableVal = (VariableValue*)[self.coreData createObj:@"VariableValue"];
	variableVal.startingValue = [NSNumber numberWithDouble:10.0];
	variableVal.name = @"Test";
	[variableVal addValueChangesObject:[self createTestValueChange:@"2012-01-01" andVal:10.0]];
	[variableVal addValueChangesObject:[self createTestValueChange:@"2013-01-01" andVal:10.0]];

	DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		[[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];
	VariableRateCalculator *varRateCalc = 
		[calcCreator createForDateSensitiveValue:variableVal andStartDate:[self dateFromStr:@"2011-01-01"]];
	[self checkOneRateCalc:varRateCalc andDaysSinceStart:0 andExpectedVal:1.0];
	[self checkOneRateCalc:varRateCalc andDaysSinceStart:365 andExpectedVal:1.1];
	[self checkOneRateCalc:varRateCalc andDaysSinceStart:730 andExpectedVal:1.21];
	[self checkOneRateCalc:varRateCalc andDaysSinceStart:1095 andExpectedVal:1.33];
	
	

}

@end
