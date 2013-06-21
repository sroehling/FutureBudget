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
#import "PeriodicInterestBearingWorkingBalance.h"

#import "LoanSimInfo.h"


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
	expectedPmtDate:(NSString*)expctedPmtDateStr inContext:(NSString*)context andExpectedBalAfterPmt:(double)expectedBal
{
    NSDate *pmtDate = [pmtRepeater nextDateOnOrAfterDate:loanInfo.simParams.simStartDate];

	[self checkDate:pmtDate vsExpected:expctedPmtDateStr inContext:context];

	double actualPaymentAmount = [loanInfo.loanBalance decrementPeriodicPaymentOnDate:pmtDate withExtraPmtAmount:0.0];

	NSLog(@"Balance before pmt: %0.2f",[loanInfo.loanBalance currentBalanceForDate:pmtDate]);
	
	double balAfterPmt = [loanInfo.loanBalance currentBalanceForDate:pmtDate];
	
	NSLog(@"Balance after pmt: %0.2f, actual pmt = %0.2f",balAfterPmt,actualPaymentAmount);
	
	[self checkValue:balAfterPmt vsExpected:expectedBal inContext:context];

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
	
	
	// The payment amount has been cross-checked with MS Excel using the function "=PMT(10%/12,12,100,0,0)"
	// The loan amortization below has also been cross-checked/verified against spreadsheet
	// amortization.

	double paymentAmount = [loanInfo.loanBalance currPeriodicPayment];

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
		expectedPmtDate:@"2012-02-01" inContext:@"testSimpleLoan: pmt 1" andExpectedBalAfterPmt:92.04];

	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-03-01" inContext:@"testSimpleLoan: pmt 2" andExpectedBalAfterPmt:84.02];

	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-04-01" inContext:@"testSimpleLoan: pmt 3" andExpectedBalAfterPmt:75.93];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-05-01" inContext:@"testSimpleLoan: pmt 4" andExpectedBalAfterPmt:67.77];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-06-01" inContext:@"testSimpleLoan: pmt 5" andExpectedBalAfterPmt:59.54];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-07-01" inContext:@"testSimpleLoan: pmt 6" andExpectedBalAfterPmt:51.24];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-08-01" inContext:@"testSimpleLoan: pmt 7" andExpectedBalAfterPmt:42.88];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-09-01" inContext:@"testSimpleLoan: pmt 8" andExpectedBalAfterPmt:34.45];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-10-01" inContext:@"testSimpleLoan: pmt 9" andExpectedBalAfterPmt:25.94];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-11-01" inContext:@"testSimpleLoan: pmt 10" andExpectedBalAfterPmt:17.37];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-12-01" inContext:@"testSimpleLoan: pmt 11" andExpectedBalAfterPmt:8.72];
		
	// Working balances accrue digest results in yearly increments, indexed by 
	// a "day index" from 0 to 365. Therefore, when testing with working balances,
	// it is necessary to advance the working balance if dates in a new year are
	// being tested.
	[loanInfo.loanBalance carryBalanceForward:[DateHelper dateFromStr:@"2013-01-01"]];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2013-01-01" inContext:@"testSimpleLoan: pmt 12" andExpectedBalAfterPmt:0.0];

		
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
	
	double simulatedStartingBalance = [loanInfo.loanBalance currentBalance];
	[self checkValue:simulatedStartingBalance vsExpected:51.24
		inContext:@"testLoanWithoutExplicitStartingBalance: Simulated Starting Balance (after 6 prior payments"];

	
	// The monthly payment has been cross-checked with MS Excel using the function "=PMT(10%/12,12,100,0,0)"
	// The loan amortization has also been cross-checked against excel
	// (MonthlyMortgageInterestCalculation.xlsx)

	double paymentAmount = [loanInfo.loanBalance currPeriodicPayment];

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
		expectedPmtDate:@"2012-01-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 1" andExpectedBalAfterPmt:42.88];
	
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-02-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 1" andExpectedBalAfterPmt:34.45];

	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-03-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 2" andExpectedBalAfterPmt:25.94];

	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-04-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 3" andExpectedBalAfterPmt:17.37];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-05-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 4" andExpectedBalAfterPmt:8.72];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-06-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 5" andExpectedBalAfterPmt:0.0];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-07-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 6" andExpectedBalAfterPmt:0.0];
		
	[self checkPmt:loanInfo andPmtRepeater:pmtRepeater 
		expectedPmtDate:@"2012-08-01" inContext:@"testLoanWithoutExplicitStartingBalance: pmt 7" andExpectedBalAfterPmt:0.0];
		
		
		
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

	double paymentAmount = [loanInfo.loanBalance currPeriodicPayment];

	[self checkValue:paymentAmount vsExpected:8.79
		inContext:@"testSimpleLoan:monthly payment"];
	
	[self checkValue:[loanInfo loanOrigAmount] vsExpected:100 
		inContext:@"testSimpleLoan:origination amount"];

	[self checkValue:[loanInfo downPaymentAmount] vsExpected:0 
		inContext:@"testSimpleLoan:down pmt amount"];

}

@end
