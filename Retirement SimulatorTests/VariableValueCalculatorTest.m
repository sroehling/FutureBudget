//
//  VariableValueCalculatorTest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueCalculatorTest.h"
#import "InMemoryCoreData.h"
#import "ValueAsOfCalculatorCreator.h"
#import "ValueAsOfCalculator.h"
#import "FixedValue.h"
#import "VariableValue.h"
#import "DateHelper.h"
#import "TestCoreDataObjects.h"

// TODO - Remove dependences of this class on the TestCoreDataObjects class, and
// place it on the InputCreationHelper. This will make this class consistent with
// the loan tests.

@implementation VariableValueCalculatorTest

@synthesize coreData;

- (void)setUp
{
	self.coreData = [[[InMemoryCoreData alloc] init] autorelease];
}

- (void)tearDown
{
	[coreData release];
}

- (void)checkOneValueAsOfWithCalc:(id<ValueAsOfCalculator>)valueCalc
		andAsOfDate:(NSString*)asOfDateStr andExpectedVal:(double)expectedVal
{
	NSDate *asOfDate = [DateHelper dateFromStr:asOfDateStr];
	
	double asOfValue = [valueCalc valueAsOfDate:asOfDate];
	STAssertEqualsWithAccuracy(asOfValue, expectedVal, 0.01,
	        @"checkOneValueAsOfWithCalc: Expecting %0.2f, got %0.2f for date = %@",
							   expectedVal,asOfValue,asOfDateStr);
	
	NSLog(@"checkOneValueAsOfWithCalc: Expecting %0.2f, got %0.2f for date = %@",
		  expectedVal,asOfValue,asOfDateStr);

}

- (void)testVariableValue
{
	VariableValue *variableVal = (VariableValue*)[self.coreData createObj:VARIABLE_VALUE_ENTITY_NAME];
	variableVal.startingValue = [NSNumber numberWithDouble:10.0];
	variableVal.name = @"Test";
	
	// Note that we add the dates out of order, testing that the calculator will sort the dates from earliest
	// to latest before returning results.
	[variableVal addValueChangesObject:[TestCoreDataObjects
										createTestValueChange:self.coreData andDate:@"2013-06-01" andVal:30.0]];

	[variableVal addValueChangesObject:[TestCoreDataObjects 
										createTestValueChange:self.coreData andDate:@"2012-01-01" andVal:20.0]];
	
	ValueAsOfCalculatorCreator *calcCreator = [[[ValueAsOfCalculatorCreator alloc] init] autorelease];
	id<ValueAsOfCalculator> valueCalc = [calcCreator createForDateSensitiveValue:variableVal];									
										
	NSLog(@"In 2011, the value should be 10");
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2011-10-01" andExpectedVal:10];
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2011-12-31" andExpectedVal:10];
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2011-12-31" andExpectedVal:10];
	
	NSLog(@"All through 2012, and through May of 2013, the value should be 20");
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2012-01-01" andExpectedVal:20];
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2012-10-15" andExpectedVal:20];
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2012-12-31" andExpectedVal:20];
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2013-01-01" andExpectedVal:20];
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2013-05-31" andExpectedVal:20];
	
	NSLog(@"Then in 2013, the value should switch from 20 to 30 in June");
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2013-06-01" andExpectedVal:30];
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2015-06-01" andExpectedVal:30];

}


- (void)testFixedValue
{
	FixedValue *fixedVal = (FixedValue*)[self.coreData createObj:FIXED_VALUE_ENTITY_NAME];
	fixedVal.value = [NSNumber numberWithDouble:1000];
	
	ValueAsOfCalculatorCreator *calcCreator = [[[ValueAsOfCalculatorCreator alloc] init] autorelease];
	id<ValueAsOfCalculator> valueCalc = [calcCreator createForDateSensitiveValue:fixedVal];
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2011-10-01" andExpectedVal:1000];
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2020-12-01" andExpectedVal:1000];
	[self checkOneValueAsOfWithCalc:valueCalc andAsOfDate:@"2012-10-01" andExpectedVal:1000];

}

@end
