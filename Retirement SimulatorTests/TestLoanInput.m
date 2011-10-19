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
#import "WorkingBalanceAdjustment.h"
#import "BalanceAdjustment.h"
#import "InterestBearingWorkingBalance.h"
#import "FixedValue.h"
#import "SimParams.h"
#import "LoanInput.h"
#import "SharedAppValues.h"
#import "EventRepeater.h"
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
	theLoan.loanEnabled = [testObjs multiScenBoolValWithDefault:TRUE];
	
	// Loan Cost
	theLoan.multiScenarioLoanCostAmt = [testObjs multiScenFixedValWithDefault:loanCost];
	theLoan.loanDuration = [testObjs multiScenFixedValWithDefault:durationMonths];			
	theLoan.multiScenarioLoanCostGrowthRate = [testObjs multiScenFixedValWithDefault:0.0];;
	theLoan.multiScenarioOrigDate = [testObjs multiScenFixedDate:@"2012-01-01"];

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

- (void)checkDate:(NSDate*)theDate vsExpected:(NSString*)expectedDateStr inContext:(NSString*)context
{
	NSString *dateStr = [DateHelper stringFromDate:theDate];
	assert(dateStr != nil);
	
	NSLog(@"%@: expecting date = %@, got date = %@",
		context,dateStr,expectedDateStr);
			
	STAssertTrue([dateStr isEqualToString:expectedDateStr],@"%@: expecting date = %@, got date = %@",
		context,dateStr,expectedDateStr);
}

- (void)checkPmt:(LoanSimInfo*)loanInfo andPmtRepeater:(EventRepeater*)pmtRepeater
	expectedPmtDate:(NSString*)expctedPmtDateStr inContext:(NSString*)context
{
	NSDate *pmtDate = [pmtRepeater nextDate];
	[self checkDate:pmtDate vsExpected:expctedPmtDateStr inContext:context];
	
	double paymentAmount = [loanInfo monthlyPayment];
	
	NSLog(@"Balance before pmt: %0.2f",[loanInfo.loanBalance currentBalance]);
	WorkingBalanceAdjustment *loanPmtAdjustment = 
			[loanInfo.loanBalance decrementAvailableBalance:paymentAmount asOfDate:pmtDate];
	NSLog(@"Balance after pmt: %0.2f",[loanInfo.loanBalance currentBalance]);
	NSLog(@"Interest in pmt: %0.2f",loanPmtAdjustment.interestAdjustement.taxableAmount);

}


- (void)testSimpleLoan
{	
	LoanInput *theLoan  = [self createTestLoanWithLoanCost:100 
		andDuration:12 andInterestRate:10 andDownPmtPercent:0 andExtraPmtAmt:0];
		
	SimParams *simParams = [[[SimParams alloc] 
		initWithStartDate:[DateHelper dateFromStr:@"2012-01-01"] 
		andScenario:self.testObjs.testScenario] autorelease];
	LoanSimInfo *loanInfo = [[[LoanSimInfo alloc] initWithLoan:theLoan andSimParams:simParams] autorelease];
	
	
	// Cross-checked with MS Excel using the function "=PMT(10%/12,12,100,0,0)"

	double paymentAmount = [loanInfo monthlyPayment];

	[self checkValue:paymentAmount vsExpected:8.79 
		inContext:@"testSimpleLoan:monthly payment"];
	
	[self checkValue:[loanInfo loanOrigAmount] vsExpected:100 
		inContext:@"testSimpleLoan:origination amount"];

	[self checkValue:[loanInfo downPaymentAmount] vsExpected:0 
		inContext:@"testSimpleLoan:down pmt amount"];
	
	[self checkDate:[loanInfo loanOrigDate] vsExpected:@"2012-01-01" 
		inContext:@"testSimpleLoan:origination date"];

	EventRepeater *pmtRepeater = [loanInfo createLoanPmtRepeater];
	
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-02-01" inContext:@"testSimpleLoan: pmt 1"];

	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-03-01" inContext:@"testSimpleLoan: pmt 2"];

	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-04-01" inContext:@"testSimpleLoan: pmt 3"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-05-01" inContext:@"testSimpleLoan: pmt 4"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-06-01" inContext:@"testSimpleLoan: pmt 5"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-07-01" inContext:@"testSimpleLoan: pmt 6"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-08-01" inContext:@"testSimpleLoan: pmt 7"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-09-01" inContext:@"testSimpleLoan: pmt 8"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-10-01" inContext:@"testSimpleLoan: pmt 9"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-11-01" inContext:@"testSimpleLoan: pmt 10"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-12-01" inContext:@"testSimpleLoan: pmt 11"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2013-01-01" inContext:@"testSimpleLoan: pmt 12"];

		
}



@end
