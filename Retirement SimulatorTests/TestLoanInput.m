//
//  TestLoanInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestLoanInput.h"

#import "InMemoryCoreData.h"
#import "MultiScenarioInputValue.h"
#import "TestCoreDataObjects.h"
#import "DateHelper.h"

#import "FixedValue.h"
#import "SimParams.h"
#import "LoanInput.h"
#import "SharedAppValues.h"
#import "DefaultScenario.h"

#import "LoanSimInfo.h"


@implementation TestLoanInput

@synthesize coreData;
@synthesize testObjs;


- (void)setUp
{
	self.coreData = [[[InMemoryCoreData alloc] init] autorelease];
	self.testObjs = [[[TestCoreDataObjects alloc] initWithCoreData:self.coreData] autorelease];
}

- (void)tearDown
{
	[coreData release];
	[testObjs release];
}

- (LoanInput*)createTestLoanWithLoanCost:(double)loanCost 
	andDuration:(double)durationMonths 
	andInterestRate:(double)interestRate
	andDownPmtPercent:(double)downPmtPercent
	andExtraPmtAmt:(double)extraPmt
{
	LoanInput *theLoan  = (LoanInput*)[self.coreData createObj:LOAN_INPUT_ENTITY_NAME];
	
	theLoan.startingBalance = [NSNumber numberWithDouble:0.0];
	theLoan.multiScenarioLoanEnabled = [testObjs multiScenBoolValWithDefault:TRUE];
	
	// Loan Cost
	theLoan.multiScenarioLoanCostAmt = [testObjs multiScenFixedValWithDefault:loanCost];
	theLoan.multiScenarioLoanDuration = [testObjs multiScenFixedValWithDefault:durationMonths];			
	theLoan.multiScenarioLoanCostGrowthRate = [testObjs multiScenFixedValWithDefault:0.0];;
	theLoan.multiScenarioOrigDate = [testObjs multiScenFixedDateWithDefaultToday];

	// Interest
	theLoan.multiScenarioInterestRate = [testObjs multiScenFixedValWithDefault:interestRate];
	theLoan.taxableInterest = [NSNumber numberWithBool:TRUE];		
		
	// Down Payment	
	theLoan.multiScenarioDownPmtEnabled = [testObjs multiScenBoolValWithDefault:TRUE];
	theLoan.multiScenarioDownPmtPercent = [testObjs multiScenFixedValWithDefault:downPmtPercent];


	// Extra Payments 
	theLoan.multiScenarioExtraPmtEnabled = [testObjs multiScenBoolValWithDefault:TRUE];
	theLoan.multiScenarioExtraPmtAmt = [testObjs multiScenFixedValWithDefault:extraPmt];
	theLoan.multiScenarioExtraPmtGrowthRate = [testObjs multiScenFixedValWithDefault:0.0];
	
	theLoan.multiScenarioExtraPmtFrequency = [testObjs multiScenarioRepeatFrequencyOnce];
	
	return theLoan;


}

- (void)checkValue:(double)theValue vsExpected:(double)expectedVal inContext:(NSString*)context
{
	NSLog(@"%@: expected = %0.2f, got %0.2f",context,expectedVal,theValue);
	STAssertEqualsWithAccuracy(theValue, expectedVal, 0.01,
	        @"%@ expected = %0.2f, got %0.2f", context,  expectedVal,theValue);
}

- (void)testSimpleLoan
{	
	LoanInput *theLoan  = [self createTestLoanWithLoanCost:100 
		andDuration:12 andInterestRate:14.34600 andDownPmtPercent:0 andExtraPmtAmt:0];
		
	SimParams *simParams = [[[SimParams alloc] 
		initWithStartDate:[DateHelper dateFromStr:@"2012-01-01"] 
		andScenario:self.testObjs.testScenario] autorelease];
	LoanSimInfo *loanInfo = [[[LoanSimInfo alloc] initWithLoan:theLoan andSimParams:simParams] autorelease];
	
	[self checkValue:[loanInfo monthlyPayment] vsExpected:9.0 inContext:@"testSimpleLoan:monthly payment"];
}



@end
