//
//  TestLoanInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestLoanInput.h"

#import "DataModelController.h"
#import "MultiScenarioInputValue.h"
#import "DateHelper.h"
#import "InterestBearingWorkingBalance.h"
#import "FixedValue.h"
#import "SimParams.h"
#import "LoanInput.h"
#import "SharedAppValues.h"
#import "EventRepeater.h"
#import "DefaultScenario.h"
#import "InputCreationHelper.h"

#import "LoanSimInfo.h"
#import "LoanSimConfigParams.h"


@implementation TestLoanInput

@synthesize coreData;
@synthesize testAppVals;


- (void)setUp
{
	self.coreData = [[[DataModelController alloc] initForInMemoryStorage] autorelease];
	self.testAppVals = [SharedAppValues createWithDataModelInterface:self.coreData];
}

- (void)tearDown
{
	[coreData release];
	[testAppVals release];
}

- (LoanInput*)createTestLoanWithLoanCost:(double)loanCost 
	andDuration:(double)durationMonths 
	andInterestRate:(double)interestRate
	andDownPmtPercent:(double)downPmtPercent
	andExtraPmtAmt:(double)extraPmt
{
	LoanInput *theLoan  = (LoanInput*)[self.coreData createDataModelObject:LOAN_INPUT_ENTITY_NAME];
	
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc]
		initWithDataModelController:self.coreData andSharedAppVals:testAppVals] autorelease];
	
	theLoan.startingBalance = [NSNumber numberWithDouble:0.0];
	theLoan.loanEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];

	// Loan Cost
	theLoan.loanCost = [inputCreationHelper multiScenAmountWithDefault:loanCost];
	theLoan.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:durationMonths];
	theLoan.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	NSDate *origDate = [DateHelper dateFromStr:@"2012-01-01"];
	theLoan.origDate = [inputCreationHelper multiScenSimDateWithDefault:origDate];
	
	// Interest
	theLoan.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:interestRate];	

	// Down Payment	
	theLoan.downPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	theLoan.multiScenarioDownPmtPercent = [inputCreationHelper multiScenFixedValWithDefault:downPmtPercent];
	
	
	// Extra Payments
	theLoan.extraPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	theLoan.extraPmtAmt = [inputCreationHelper multiScenAmountWithDefault:extraPmt];
	theLoan.extraPmtGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	theLoan.extraPmtFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	
	theLoan.earlyPayoffDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];

	// Deferred Payments
	
	theLoan.deferredPaymentEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	theLoan.deferredPaymentPayInterest = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	theLoan.deferredPaymentSubsizedInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];

	theLoan.deferredPaymentDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];


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
    NSDate *pmtDate = [pmtRepeater nextDateOnOrAfterDate:loanInfo.simParams.simStartDate];

	[self checkDate:pmtDate vsExpected:expctedPmtDateStr inContext:context];
	
	double paymentAmount = [loanInfo monthlyPaymentForPaymentsStartingAtLoanOrig];
	
	NSLog(@"Balance before pmt: %0.2f",[loanInfo.loanBalance currentBalanceForDate:pmtDate]);
	[loanInfo.loanBalance decrementAvailableBalanceForNonExpense:paymentAmount asOfDate:pmtDate];
	NSLog(@"Balance after pmt: %0.2f",[loanInfo.loanBalance currentBalanceForDate:pmtDate]);

}


- (void)testSimpleLoan
{	
	LoanInput *theLoan  = [self createTestLoanWithLoanCost:100 
		andDuration:12 andInterestRate:10 andDownPmtPercent:0 andExtraPmtAmt:0];
		
		
	SimParams *simParams = [[[SimParams alloc] initWithStartDate:[DateHelper dateFromStr:@"2012-01-01"] andDigestStartDate:[DateHelper dateFromStr:@"2012-01-01"] andSimEndDate:[DateHelper dateFromStr:@"2013-01-01"] 
		andScenario:self.testAppVals.defaultScenario andCashBal:0.0 
			andDeficitRate:self.testAppVals.deficitInterestRate andDeficitBalance:0.0
		andInflationRate:testAppVals.defaultInflationRate] autorelease];	
	LoanSimInfo *loanInfo = [[[LoanSimInfo alloc] initWithLoan:theLoan andSimParams:simParams] autorelease];
	
	
	// Cross-checked with MS Excel using the function "=PMT(10%/12,12,100,0,0)"

	double paymentAmount = [loanInfo monthlyPaymentForPaymentsStartingAtLoanOrig];

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
		
	// Working balances accrue digest results in yearly increments, indexed by 
	// a "day index" from 0 to 365. Therefore, when testing with working balances,
	// it is necessary to advance the working balance if dates in a new year are
	// being tested.
	[loanInfo.loanBalance carryBalanceForward:[DateHelper dateFromStr:@"2013-01-01"]];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2013-01-01" inContext:@"testSimpleLoan: pmt 12"];

		
}

- (void)testLoanWithoutExplicitStartingBalance
{	
	LoanInput *theLoan  = [self createTestLoanWithLoanCost:100
		andDuration:12 andInterestRate:10 andDownPmtPercent:0 andExtraPmtAmt:0];
		
	// Override the origination date to 6 months before the simulation start, and
	// set the starting balance to undefined/nil. This will cause the simulation
	// engine to calculate a starting balance based on the payments made before
	// the start date.
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initWithDataModelController:self.coreData andSharedAppVals:testAppVals] autorelease];
	theLoan.startingBalance = nil;
	NSDate *origDate = [DateHelper dateFromStr:@"2011-06-01"];
	theLoan.origDate = [inputCreationHelper multiScenSimDateWithDefault:origDate];
		
		
	SimParams *simParams = [[[SimParams alloc]
		initWithStartDate:[DateHelper dateFromStr:@"2012-01-01"]
		andDigestStartDate:[DateHelper dateFromStr:@"2012-01-01"]
		andSimEndDate:[DateHelper dateFromStr:@"2013-01-01"]
		andScenario:self.testAppVals.defaultScenario andCashBal:0.0 
			andDeficitRate:self.testAppVals.deficitInterestRate andDeficitBalance:0.0
		andInflationRate:testAppVals.defaultInflationRate] autorelease];
		
	LoanSimInfo *loanInfo = [[[LoanSimInfo alloc] initWithLoan:theLoan andSimParams:simParams] autorelease];
	
	LoanSimConfigParams *configParams = [loanInfo configParamsForLoanOrigination];
	double simulatedStartingBalance = configParams.startingBal;
	[self checkValue:simulatedStartingBalance vsExpected:51.26
		inContext:@"testLoanWithoutExplicitStartingBalance: Simulated Starting Balance (after 6 prior payments"];

	
	// Cross-checked with MS Excel using the function "=PMT(10%/12,12,100,0,0)"

	double paymentAmount = [loanInfo monthlyPaymentForPaymentsStartingAtLoanOrig];

	[self checkValue:paymentAmount vsExpected:8.79 
		inContext:@"testLoanWithoutExplicitStartingBalance:monthly payment"];
	
	[self checkValue:[loanInfo loanOrigAmount] vsExpected:100 
		inContext:@"testLoanWithoutExplicitStartingBalance:origination amount"];

	[self checkValue:[loanInfo downPaymentAmount] vsExpected:0 
		inContext:@"testLoanWithoutExplicitStartingBalance:down pmt amount"];
	
	[self checkDate:[loanInfo loanOrigDate] vsExpected:@"2011-06-01" 
		inContext:@"testLoanWithoutExplicitStartingBalance:origination date"];

	EventRepeater *pmtRepeater = [loanInfo createLoanPmtRepeater];

	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-01-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 1"];
	
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-02-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 1"];

	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-03-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 2"];

	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-04-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 3"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-05-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 4"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-06-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 5"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-07-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 6"];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-08-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 7"];
		
		
		
}


- (void)testDeferredPaymentAmount
{	
	LoanInput *theLoan  = [self createTestLoanWithLoanCost:100
		andDuration:12 andInterestRate:10 andDownPmtPercent:0 andExtraPmtAmt:0];
		
		
	SimParams *simParams = [[[SimParams alloc] initWithStartDate:[DateHelper dateFromStr:@"2012-01-01"] andDigestStartDate:[DateHelper dateFromStr:@"2012-01-01"] andSimEndDate:[DateHelper dateFromStr:@"2013-01-01"] 
		andScenario:self.testAppVals.defaultScenario andCashBal:0.0 
			andDeficitRate:self.testAppVals.deficitInterestRate andDeficitBalance:0.0
		andInflationRate:testAppVals.defaultInflationRate] autorelease];	
	LoanSimInfo *loanInfo = [[[LoanSimInfo alloc] initWithLoan:theLoan andSimParams:simParams] autorelease];
	
	
	// Cross-checked with MS Excel using the function "=PMT(10%/12,12,100,0,0)"
	
	// Test the lower-level method used to calculate the monthly payments for both payments starting on
	// the origination date or on the deferred date.

	double paymentAmount = [loanInfo monthlyPaymentForPmtCalcDate:[DateHelper dateFromStr:@"2013-01-01"]
			andStartingBal:100.0];

	[self checkValue:paymentAmount vsExpected:8.79
		inContext:@"testSimpleLoan:monthly payment"];
	
	[self checkValue:[loanInfo loanOrigAmount] vsExpected:100 
		inContext:@"testSimpleLoan:origination amount"];

	[self checkValue:[loanInfo downPaymentAmount] vsExpected:0 
		inContext:@"testSimpleLoan:down pmt amount"];

}

@end
