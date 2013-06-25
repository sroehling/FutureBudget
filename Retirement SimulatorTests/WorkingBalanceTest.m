//
//  WorkingBalanceTest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingBalanceTest.h"
#import "CashWorkingBalance.h"
#import "AccountWorkingBalance.h"
#import "DataModelController.h"
#import "WorkingBalance.h"
#import "DateHelper.h"
#import "VariableValue.h"
#import "FixedValue.h"
#import "InterestBearingWorkingBalance.h"
#import "WorkingBalanceMgr.h"
#import "PeriodicInterestBearingWorkingBalance.h"
#import "TestCoreDataObjects.h"
#import "EventRepeater.h"
#import "PeriodicInterestPaymentResult.h"


@implementation WorkingBalanceTest

@synthesize coreData;


- (void)setUp
{
	self.coreData = [[[DataModelController alloc] initForInMemoryStorage] autorelease];
}

- (void)tearDown
{
	[coreData release];
}

-(FixedValue*)createInterestRate:(double)theInterestRate
{
	FixedValue *fixedInterestRate =  
		(FixedValue*)[self.coreData createDataModelObject:FIXED_VALUE_ENTITY_NAME];
	fixedInterestRate.value =  [NSNumber numberWithDouble:theInterestRate];
	return fixedInterestRate;
}

- (InterestBearingWorkingBalance*)createInterestBearingWorkingAccountWithRate:(double)interestRate
	andStartDate:(NSDate*)startDate andStartingBal:(double)startBalance
{
	FixedValue *fixedInterestRate = [self createInterestRate:interestRate];
	
	InterestBearingWorkingBalance *workingBal = 
		[[[InterestBearingWorkingBalance alloc] initWithStartingBalance:startBalance andInterestRate:fixedInterestRate andWorkingBalanceName:@"TestAcct" 
		andStartDate:startDate andWithdrawPriority:WORKING_BALANCE_WITHDRAW_PRIORITY_MAX] autorelease];
	
	return workingBal;

}


- (void)checkCurrentBalance:(id<WorkingBalance>)bal withExpectedBalance:(double)expectedBal andDate:(NSDate*)currentDate
{
	STAssertEqualsWithAccuracy([bal currentBalanceForDate:currentDate], expectedBal, 0.01,
	        @"checkOneValueAsOfWithCalc: Expecting %0.2f, got %0.2f for working balance = %@",
							   expectedBal,[bal currentBalanceForDate:currentDate],bal.balanceName);
}

- (void)checkAvailableBalanceDecrement:(id<WorkingBalance>)bal
	decrementAmount:(double)decrAmt 
	onDate:(NSDate*)decrDate
	andExpectedAvailAmt:(double)expectedAvail
	withExpectedBalanceBefore:(double)expectedBalBefore
	andExpectedBalanceAfter:(double)expectedBalAfter
{

	STAssertEqualsWithAccuracy([bal currentBalanceForDate:decrDate], expectedBalBefore, 0.001,
	@"checkAvailableBalanceDecrement: Expecting %0.2f, got %0.2f for working balance = %@ (before decrement)",
							   expectedBalBefore,[bal currentBalanceForDate:decrDate],bal.balanceName);

	double avail = [bal decrementAvailableBalanceForNonExpense:decrAmt asOfDate:decrDate];
		STAssertEqualsWithAccuracy(expectedAvail, avail, 0.001,
	@"checkAvailableBalanceDecrement: Expecting %0.2f, got %0.2f for available balance = %@",
							   expectedAvail,avail,bal.balanceName);
		
	STAssertEqualsWithAccuracy([bal currentBalanceForDate:decrDate], expectedBalAfter, 0.001,
		@"checkAvailableBalanceDecrement: Expecting %0.2f, got %0.2f for working balance = %@ after decrement",
							   expectedBalAfter,[bal currentBalanceForDate:decrDate],bal.balanceName);
}


- (void)doZeroInterestTests:(id<WorkingBalance>)bal
{
	[self checkCurrentBalance:bal withExpectedBalance:1000 andDate:[DateHelper dateFromStr:@"2012-01-01"]];
	
	[bal incrementBalance:1000.0 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:bal withExpectedBalance:2000.0 andDate:[DateHelper dateFromStr:@"2012-01-01"]];

	[bal carryBalanceForward:[DateHelper dateFromStr:@"2013-01-01"]];
	[self checkCurrentBalance:bal withExpectedBalance:2000.0 andDate:[DateHelper dateFromStr:@"2013-01-01"]];

	[bal decrementAvailableBalanceForNonExpense:500.0 asOfDate:[DateHelper dateFromStr:@"2013-05-01"]];
	[self checkCurrentBalance:bal withExpectedBalance:1500.0 andDate:[DateHelper dateFromStr:@"2013-05-01"]];
	
	[self checkAvailableBalanceDecrement:bal 
		decrementAmount:500 onDate:[DateHelper dateFromStr:@"2013-05-02"]
		andExpectedAvailAmt:500
		withExpectedBalanceBefore:1500 andExpectedBalanceAfter:1000 ];

	[self checkAvailableBalanceDecrement:bal 
		decrementAmount:0 onDate:[DateHelper dateFromStr:@"2013-05-02"]
		andExpectedAvailAmt:0
		withExpectedBalanceBefore:1000 andExpectedBalanceAfter:1000 ];

	[self checkAvailableBalanceDecrement:bal 
		decrementAmount:1200 onDate:[DateHelper dateFromStr:@"2013-05-02"]
		andExpectedAvailAmt:1000
		withExpectedBalanceBefore:1000 andExpectedBalanceAfter:0 ];

	[self checkAvailableBalanceDecrement:bal 
		decrementAmount:1000 onDate:[DateHelper dateFromStr:@"2013-05-02"]
		andExpectedAvailAmt:0
		withExpectedBalanceBefore:0 andExpectedBalanceAfter:0 ];

	[self checkAvailableBalanceDecrement:bal 
		decrementAmount:0 onDate:[DateHelper dateFromStr:@"2013-05-02"]
		andExpectedAvailAmt:0
		withExpectedBalanceBefore:0 andExpectedBalanceAfter:0 ];

}


- (void)test100InterestSavingsBalance
{
	NSDate *startDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2011-01-01"]];
	InterestBearingWorkingBalance *bal = [self createInterestBearingWorkingAccountWithRate:100 andStartDate:startDate andStartingBal:1000];
	
	[bal carryBalanceForward:[DateHelper dateFromStr:@"2012-01-01"]];

	[self checkCurrentBalance:bal withExpectedBalance:2000 andDate:[DateHelper dateFromStr:@"2012-01-01"]];

	[bal incrementBalance:1000.0 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:bal withExpectedBalance:3000 andDate:[DateHelper dateFromStr:@"2012-01-01"]];

	[bal decrementAvailableBalanceForNonExpense:1000.0 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:bal withExpectedBalance:2000 andDate:[DateHelper dateFromStr:@"2012-01-01"]];
	
}

- (void)testZeroInterestSavingsBalance
{
	NSDate *startDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2012-01-01"]];
	InterestBearingWorkingBalance *bal = [self createInterestBearingWorkingAccountWithRate:0 andStartDate:startDate andStartingBal:1000];
	
	[self doZeroInterestTests:bal];
}

- (void)testDeferredWithdrawals
{

	NSDate *startDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2011-01-01"]];
	double startingBal = 1000.0;
	NSDate *deferUntilDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2012-01-01"]];
	
	
	AccountWorkingBalance *acctBal = [[[AccountWorkingBalance alloc] initWithWithdrawalPriority:1.0
	andStartDate:startDate andStartingBal:startingBal andInterestRate:[self createInterestRate:0.0]
		andStartingCostBasis:startingBal andDeferWithdrawDate:deferUntilDate andLimitedExpense:nil] autorelease];
	
	[acctBal decrementAvailableBalanceForNonExpense:250.0 asOfDate:[DateHelper dateFromStr:@"2011-01-01"]];
	[self checkCurrentBalance:acctBal withExpectedBalance:startingBal andDate:[DateHelper dateFromStr:@"2011-01-01"]];

	[acctBal decrementAvailableBalanceForNonExpense:250.0 asOfDate:[DateHelper dateFromStr:@"2011-07-01"]];
	[self checkCurrentBalance:acctBal withExpectedBalance:startingBal andDate:[DateHelper dateFromStr:@"2011-07-01"]];

	[acctBal decrementAvailableBalanceForNonExpense:250.0 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:acctBal withExpectedBalance:750.0 andDate:[DateHelper dateFromStr:@"2012-01-01"]];
	
	[acctBal carryBalanceForward:[DateHelper dateFromStr:@"2012-01-01"]];
	
	[acctBal decrementAvailableBalanceForNonExpense:250.0 asOfDate:[DateHelper dateFromStr:@"2012-08-01"]];
	[self checkCurrentBalance:acctBal withExpectedBalance:500.0 andDate:[DateHelper dateFromStr:@"2012-08-01"]];
	
		
	acctBal = [[[AccountWorkingBalance alloc] initWithWithdrawalPriority:1.0
	andStartDate:startDate andStartingBal:startingBal andInterestRate:[self createInterestRate:0.0]
		andStartingCostBasis:startingBal andDeferWithdrawDate:deferUntilDate andLimitedExpense:nil] autorelease];
	
	[acctBal decrementAvailableBalanceForNonExpense:250.0 asOfDate:[DateHelper dateFromStr:@"2011-01-01"]];
	[self checkCurrentBalance:acctBal withExpectedBalance:startingBal andDate:[DateHelper dateFromStr:@"2011-01-01"]];

	[acctBal decrementAvailableBalanceForNonExpense:250.0 asOfDate:[DateHelper dateFromStr:@"2011-07-01"]];
	[self checkCurrentBalance:acctBal withExpectedBalance:startingBal andDate:[DateHelper dateFromStr:@"2011-07-01"]];
	
	[acctBal decrementAvailableBalanceForNonExpense:250.0 asOfDate:[DateHelper dateFromStr:@"2011-12-31"]];
	[self checkCurrentBalance:acctBal withExpectedBalance:startingBal andDate:[DateHelper dateFromStr:@"2011-12-31"]];

	[acctBal carryBalanceForward:[DateHelper dateFromStr:@"2012-01-01"]];


	[acctBal decrementAvailableBalanceForNonExpense:250.0 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:acctBal withExpectedBalance:750.0 andDate:[DateHelper dateFromStr:@"2012-01-01"]];
	
	[acctBal decrementAvailableBalanceForNonExpense:250.0 asOfDate:[DateHelper dateFromStr:@"2012-08-01"]];
	[self checkCurrentBalance:acctBal withExpectedBalance:500.0 andDate:[DateHelper dateFromStr:@"2012-08-01"]];

}



- (void)testCashBalance
{
	CashWorkingBalance *bal = [[[CashWorkingBalance alloc] 
		initWithStartingBalance:1000.0 
		andStartDate:[DateHelper dateFromStr:@"2012-01-01"]] autorelease];
	[self doZeroInterestTests:bal];
}


- (void)testWorkingBalanceMgr
{

	NSDate *startDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2012-01-01"]];
	
	CashWorkingBalance *cashBal = [[[CashWorkingBalance alloc] 
		initWithStartingBalance:1000.0 
		andStartDate:startDate] autorelease];
	InterestBearingWorkingBalance *deficitBal = [self createInterestBearingWorkingAccountWithRate:0 
		andStartDate:startDate andStartingBal:0];

	WorkingBalanceMgr *workingBalMgr = [[[WorkingBalanceMgr alloc] initWithCashBalance:cashBal andDeficitBalance:deficitBal andStartDate:startDate] autorelease];
	
	double totalBal = [workingBalMgr totalCurrentNetBalance:startDate];
	STAssertEqualsWithAccuracy(totalBal, 1000.0, 0.001,
		@"testWorkingBalanceMgr: Expecting %0.2f, got %0.2f for total working balance",
							   1000.0,totalBal);

	
	[self checkCurrentBalance:cashBal withExpectedBalance:1000 andDate:startDate];
	[self checkCurrentBalance:deficitBal withExpectedBalance:0 andDate:startDate];
	
	[workingBalMgr incrementCashBalance:1000 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:2000 andDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:deficitBal withExpectedBalance:0 andDate:[DateHelper dateFromStr:@"2012-01-01"]];
	
	double decrementCashAmount = [workingBalMgr decrementAvailableCashBalance:1000 asOfDate:[DateHelper dateFromStr:@"2012-01-02"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:1000 andDate:[DateHelper dateFromStr:@"2012-01-02"]];
	[self checkCurrentBalance:deficitBal withExpectedBalance:0 andDate:[DateHelper dateFromStr:@"2012-01-02"]];
	STAssertEqualsWithAccuracy(decrementCashAmount, 1000.0, 0.001,
		@"testWorkingBalanceMgr: Expecting %0.2f, got %0.2f for decrement amount",
							   1000.0,decrementCashAmount);

	[workingBalMgr decrementAvailableCashBalance:1000 asOfDate:[DateHelper dateFromStr:@"2012-01-02"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:0 andDate:[DateHelper dateFromStr:@"2012-01-02"]];
	[self checkCurrentBalance:deficitBal withExpectedBalance:0 andDate:[DateHelper dateFromStr:@"2012-01-02"]];

	double decrementAmount = [workingBalMgr decrementBalanceFromFundingList:1000 
		asOfDate:[DateHelper dateFromStr:@"2012-01-02"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:0 andDate:[DateHelper dateFromStr:@"2012-01-02"]];
	[self checkCurrentBalance:deficitBal withExpectedBalance:1000 andDate:[DateHelper dateFromStr:@"2012-01-02"]];
	STAssertEqualsWithAccuracy(decrementAmount, 0.0, 0.001,
		@"testWorkingBalanceMgr: Expecting %0.2f, got %0.2f for decrement amount",
							   0.0,decrementAmount);
	
	[workingBalMgr incrementCashBalance:500 asOfDate:[DateHelper dateFromStr:@"2012-01-03"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:0 andDate:[DateHelper dateFromStr:@"2012-01-03"]];
	[self checkCurrentBalance:deficitBal withExpectedBalance:500 andDate:[DateHelper dateFromStr:@"2012-01-03"]];
	
	[workingBalMgr incrementCashBalance:1000 asOfDate:[DateHelper dateFromStr:@"2012-01-03"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:500 andDate:[DateHelper dateFromStr:@"2012-01-03"]];
	[self checkCurrentBalance:deficitBal withExpectedBalance:0 andDate:[DateHelper dateFromStr:@"2012-01-03"]];



}


- (void)testFutureInterestBearingBal
{
	NSDate *startDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2013-05-01"]];
	double startingBal = 1000.0;

	InterestBearingWorkingBalance *interestBal = [self 
		createInterestBearingWorkingAccountWithRate:0.0 andStartDate:startDate 
	andStartingBal:startingBal];

	NSDate *advanceDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2013-01-01"]];
	
	[interestBal advanceCurrentBalanceToDate:advanceDate];
}

-(void)checkPeriodicPaymentForWorkingBal:(PeriodicInterestBearingWorkingBalance*)workingBal
	WithEventRepeater:(EventRepeater*)pmtRepeater
	andExpectedPmtAmount:(double)expectedPmt andExpectedBal:(double)expectedBal
{
	NSDate *pmtDate = [pmtRepeater nextDate];
	assert(pmtDate != nil);
	
	double actualPmtAmount = [workingBal decrementPeriodicPaymentOnDate:pmtDate withExtraPmtAmount:0.0];
	
	STAssertEqualsWithAccuracy(actualPmtAmount, expectedPmt, 0.01,
	@"checkPeriodicPaymentForWorkingBal: Expecting %0.2f, got %0.2f for working balance = %@ after decrement",
						   expectedPmt,actualPmtAmount,workingBal.workingBalanceName);

	
	[self checkCurrentBalance:workingBal withExpectedBalance:expectedBal andDate:pmtDate];
	
	NSLog(@"checkPeriodicPaymentForWorkingBal: date=%@ balance=%@, got pmt=%0.2f, got bal=%0.02f",
			[[DateHelper theHelper].mediumDateFormatter stringFromDate:pmtDate],
			workingBal.workingBalanceName,actualPmtAmount,[workingBal currentBalance]);
		
}

-(void)checkFirstNonDeferredPeriodicPaymentForWorkingBal:(PeriodicInterestBearingWorkingBalance*)workingBal
	WithEventRepeater:(EventRepeater*)pmtRepeater
	andExpectedPmtAmount:(double)expectedPmt andExpectedBal:(double)expectedBal
{
	NSDate *pmtDate = [pmtRepeater nextDate];
	assert(pmtDate != nil);
	
	double actualPmtAmount = [workingBal decrementFirstNonDeferredPeriodicPaymentOnDate:pmtDate
		withExtraPmtAmount:0.0];
	
	STAssertEqualsWithAccuracy(actualPmtAmount, expectedPmt, 0.01,
	@"checkPeriodicPaymentForWorkingBal: Expecting %0.2f, got %0.2f for working balance = %@ after decrement",
						   expectedPmt,actualPmtAmount,workingBal.workingBalanceName);

	
	[self checkCurrentBalance:workingBal withExpectedBalance:expectedBal andDate:pmtDate];
	
	NSLog(@"checkPeriodicPaymentForWorkingBal: date=%@ balance=%@, got pmt=%0.2f, got bal=%0.02f",
			[[DateHelper theHelper].mediumDateFormatter stringFromDate:pmtDate],
			workingBal.workingBalanceName,actualPmtAmount,[workingBal currentBalance]);
		
}

-(void)checkDeferredPeriodicPaymentForWorkingBal:(PeriodicInterestBearingWorkingBalance*)workingBal
	WithEventRepeater:(EventRepeater*)pmtRepeater andExpectedBal:(double)expectedBal
{
	NSDate *pmtDate = [pmtRepeater nextDate];
	assert(pmtDate != nil);
	
	[workingBal skippedPaymentOnDate:pmtDate withExtraPmtAmount:0.0];
	
	[self checkCurrentBalance:workingBal withExpectedBalance:expectedBal andDate:pmtDate];
	
	NSLog(@"checkPeriodicPaymentForWorkingBal: date=%@, balance=%@, got bal=%0.02f",
			[[DateHelper theHelper].mediumDateFormatter stringFromDate:pmtDate],
			workingBal.workingBalanceName,[workingBal currentBalance]);
		
}

-(void)checkInterestOnlyPeriodicPaymentForWorkingBal:(PeriodicInterestBearingWorkingBalance*)workingBal
	WithEventRepeater:(EventRepeater*)pmtRepeater andExpectedInterst:(double)expectedInterestAmt
	andExpectedBal:(double)expectedBal
{
	NSDate *pmtDate = [pmtRepeater nextDate];
	assert(pmtDate != nil);
	
	PeriodicInterestPaymentResult *interestPmtResult =
		[workingBal decrementInterestOnlyPaymentOnDate:pmtDate withExtraPmtAmount:0.0];

	STAssertEqualsWithAccuracy(interestPmtResult.interestPaid, expectedInterestAmt, 0.01,
	@"checkPeriodicPaymentForWorkingBal: Expecting %0.2f, got %0.2f for interest only payment = %@ after decrement",
						   expectedInterestAmt,interestPmtResult.interestPaid,workingBal.workingBalanceName);

	
	[self checkCurrentBalance:workingBal withExpectedBalance:expectedBal andDate:pmtDate];
	
	NSLog(@"checkInterestOnlyPeriodicPaymentForWorkingBal: date=%@, balance=%@, got bal=%0.02f",
			[[DateHelper theHelper].mediumDateFormatter stringFromDate:pmtDate],
			workingBal.workingBalanceName,[workingBal currentBalance]);
		
}



- (void)testPeriodicInterestBearingBal
{
	NSDate *startDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2013-01-01"]];
	NSDate *endDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2016-01-01"]];
	double startingBal = 1000.0;
	
	// Start out with extra payment of 0.0, but change it to be 10 at the same time
	// deferred payments begin.
	VariableValue *variableInterest = (VariableValue*)[self.coreData
		createDataModelObject:VARIABLE_VALUE_ENTITY_NAME];
	variableInterest.startingValue = [NSNumber numberWithDouble:5.0];
	variableInterest.name = @"Test";

	[variableInterest addValueChangesObject:
		[TestCoreDataObjects createTestValueChange:self.coreData andDate:@"2013-12-31" andVal:10.0]];

	PeriodicInterestBearingWorkingBalance *workingBal = [[[PeriodicInterestBearingWorkingBalance alloc] initWithStartingBalance:startingBal andInterestRate:variableInterest andWorkingBalanceName:@"testPeriodicInterestBearingBal" andStartDate:startDate andNumPeriods:24] autorelease];
	
	[self checkCurrentBalance:workingBal withExpectedBalance:startingBal andDate:startDate];

	EventRepeater *pmtRepeater = [EventRepeater monthlyEventRepeaterWithStartDate:startDate andEndDate:endDate];
	[pmtRepeater nextDate]; // payments start one month after starDate
	
	// The results below are validated/cross-checked in the Spreadsheet MonthlyMortgageInterestCalculation.xls,
	// in the "ARM UT 1" tab.
	
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:960.30];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:920.43];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:880.39];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:840.19];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:799.82];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:759.28];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:718.57];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:677.69];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:636.64];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:595.42];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:554.03];
		
	[workingBal carryBalanceForward:[DateHelper dateFromStr:@"2014-01-01"]];
		
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:513.51];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:472.64];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:431.43];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:389.88];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:347.99];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:305.74];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:263.14];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:220.19];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:176.88];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:133.21];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:89.17];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:44.77];
		
	[workingBal carryBalanceForward:[DateHelper dateFromStr:@"2015-01-01"]];
		
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:0.0];
	


}

- (void)testPeriodicInterestBearingBalWithDeferredPayment
{
	NSDate *startDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2013-01-01"]];
	NSDate *endDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2016-01-01"]];
	double startingBal = 1000.0;
	
	// Start out with extra payment of 0.0, but change it to be 10 at the same time
	// deferred payments begin.
	VariableValue *variableInterest = (VariableValue*)[self.coreData
		createDataModelObject:VARIABLE_VALUE_ENTITY_NAME];
	variableInterest.startingValue = [NSNumber numberWithDouble:5.0];
	variableInterest.name = @"Test";
	[variableInterest addValueChangesObject:
		[TestCoreDataObjects createTestValueChange:self.coreData andDate:@"2013-04-30" andVal:7.5]];
	[variableInterest addValueChangesObject:
		[TestCoreDataObjects createTestValueChange:self.coreData andDate:@"2014-03-30" andVal:10.0]];

	PeriodicInterestBearingWorkingBalance *workingBal = [[[PeriodicInterestBearingWorkingBalance alloc] initWithStartingBalance:startingBal andInterestRate:variableInterest andWorkingBalanceName:@"testPeriodicInterestBearingBal" andStartDate:startDate andNumPeriods:24] autorelease];
	
	[self checkCurrentBalance:workingBal withExpectedBalance:startingBal andDate:startDate];

	EventRepeater *pmtRepeater = [EventRepeater monthlyEventRepeaterWithStartDate:startDate andEndDate:endDate];
	[pmtRepeater nextDate]; // payments start one month after starDate
	
	// The results below are validated/cross-checked in the Spreadsheet MonthlyMortgageInterestCalculation.xls,
	// in the "ARM UT 2" tab.
	[self checkDeferredPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
			andExpectedBal:1004.17];
	[self checkDeferredPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
			andExpectedBal:1008.35];
	[self checkDeferredPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
			andExpectedBal:1012.55];
	
	[self checkFirstNonDeferredPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:973.32];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:933.83];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:894.11];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:854.13];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:813.90];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:773.43];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:732.70];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:691.71];

	[workingBal carryBalanceForward:[DateHelper dateFromStr:@"2014-01-01"]];


	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:650.47];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:608.97];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.56 andExpectedBal:567.21];
		
	// Rate adjustment to 10%
		
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:525.72];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:483.88];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:441.70];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:399.16];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:356.26];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:313.01];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:269.40];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:225.43];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:181.09];

	[workingBal carryBalanceForward:[DateHelper dateFromStr:@"2015-01-01"]];


	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:136.38];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:91.30];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:45.84];
		
		
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:46.22 andExpectedBal:0.0];
	


}


- (void)testPeriodicInterestBearingBalWithInterestOnlyPayment
{
	NSDate *startDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2012-10-01"]];
	NSDate *endDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2016-01-01"]];
	double startingBal = 1000.0;
	
	// Start out with extra payment of 0.0, but change it to be 10 at the same time
	// deferred payments begin.
	VariableValue *variableInterest = (VariableValue*)[self.coreData
		createDataModelObject:VARIABLE_VALUE_ENTITY_NAME];
	variableInterest.startingValue = [NSNumber numberWithDouble:5.0];
	variableInterest.name = @"Test";
	
	// Change the intest amount to 7.5%, then back again. The amount of interest paid should adjust
	// accordingly for the interest only payments.
	[variableInterest addValueChangesObject:
		[TestCoreDataObjects createTestValueChange:self.coreData andDate:@"2012-11-15" andVal:7.5]];
	[variableInterest addValueChangesObject:
		[TestCoreDataObjects createTestValueChange:self.coreData andDate:@"2012-12-15" andVal:5.0]];

	[variableInterest addValueChangesObject:
		[TestCoreDataObjects createTestValueChange:self.coreData andDate:@"2013-12-31" andVal:10.0]];

	PeriodicInterestBearingWorkingBalance *workingBal = [[[PeriodicInterestBearingWorkingBalance alloc] initWithStartingBalance:startingBal andInterestRate:variableInterest andWorkingBalanceName:@"testPeriodicInterestBearingBal" andStartDate:startDate andNumPeriods:24] autorelease];
	
	[self checkCurrentBalance:workingBal withExpectedBalance:startingBal andDate:startDate];

	EventRepeater *pmtRepeater = [EventRepeater monthlyEventRepeaterWithStartDate:startDate andEndDate:endDate];
	[pmtRepeater nextDate]; // payments start one month after starDate
	
	// The results below are validated/cross-checked in the Spreadsheet MonthlyMortgageInterestCalculation.xls,
	// in the "ARM UT 1" tab.
	[self checkInterestOnlyPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedInterst:4.17 andExpectedBal:1000.0];
		
	// The interest rate switches to 7.5% on 11/15/2012, so the amount of interest paid
	// should adjust accordingly.
	[self checkInterestOnlyPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedInterst:6.25 andExpectedBal:1000.0];

	[workingBal carryBalanceForward:[DateHelper dateFromStr:@"2013-01-01"]];

	// The interest rate changes back to 
	[self checkInterestOnlyPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedInterst:4.17 andExpectedBal:1000.0];


	[self checkFirstNonDeferredPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:960.30];	
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:920.43];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:880.39];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:840.19];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:799.82];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:759.28];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:718.57];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:677.69];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:636.64];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:595.42];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:43.87 andExpectedBal:554.03];
		
	[workingBal carryBalanceForward:[DateHelper dateFromStr:@"2014-01-01"]];
		
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:513.51];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:472.64];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:431.43];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:389.88];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:347.99];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:305.74];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:263.14];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:220.19];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:176.88];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:133.21];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:89.17];
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:44.77];
		
	[workingBal carryBalanceForward:[DateHelper dateFromStr:@"2015-01-01"]];
		
	[self checkPeriodicPaymentForWorkingBal:workingBal WithEventRepeater:pmtRepeater
		andExpectedPmtAmount:45.15 andExpectedBal:0.0];
	


}

@end
