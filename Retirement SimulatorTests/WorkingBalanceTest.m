//
//  WorkingBalanceTest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkingBalanceTest.h"
#import "CashWorkingBalance.h"
#import "InMemoryCoreData.h"
#import "WorkingBalance.h"
#import "DateHelper.h"
#import "SavingsAccount.h"
#import "FixedValue.h"
#import "InterestBearingWorkingBalance.h"
#import "WorkingBalanceMgr.h"


@implementation WorkingBalanceTest

@synthesize coreData;


- (void)setUp
{
	self.coreData = [[[InMemoryCoreData alloc] init] autorelease];
}

- (void)tearDown
{
	[coreData release];
}

- (InterestBearingWorkingBalance*)createInterestBearingWorkingAccountWithRate:(double)interestRate
	andStartDate:(NSDate*)startDate andStartingBal:(double)startBalance
{
	FixedValue *fixedInterestRate =  
		(FixedValue*)[self.coreData createObj:FIXED_VALUE_ENTITY_NAME];
	fixedInterestRate.value =  [NSNumber numberWithDouble:interestRate];
	
	InterestBearingWorkingBalance *workingBal = 
		[[[InterestBearingWorkingBalance alloc] initWithStartingBalance:startBalance andInterestRate:fixedInterestRate andWorkingBalanceName:@"TestAcct" 
		andStartDate:startDate andWithdrawPriority:WORKING_BALANCE_WITHDRAW_PRIORITY_MAX] autorelease];
	
	return workingBal;

}


- (void)checkCurrentBalance:(WorkingBalance*)bal withExpectedBalance:(double)expectedBal
{
	[bal logBalance];
	STAssertEqualsWithAccuracy(bal.currentBalance, expectedBal, 0.01,
	        @"checkOneValueAsOfWithCalc: Expecting %0.2f, got %0.2f for working balance = %@",
							   expectedBal,bal.currentBalance,bal.balanceName);
}

- (void)checkAvailableBalanceDecrement:(WorkingBalance*)bal
	decrementAmount:(double)decrAmt 
	onDate:(NSDate*)decrDate
	andExpectedAvailAmt:(double)expectedAvail
	withExpectedBalanceBefore:(double)expectedBalBefore
	andExpectedBalanceAfter:(double)expectedBalAfter
{

	STAssertEqualsWithAccuracy(bal.currentBalance, expectedBalBefore, 0.001,
	@"checkAvailableBalanceDecrement: Expecting %0.2f, got %0.2f for working balance = %@ (before decrement)",
							   expectedBalBefore,bal.currentBalance,bal.balanceName);

	double avail = [bal decrementAvailableBalance:decrAmt asOfDate:decrDate];
		STAssertEqualsWithAccuracy(expectedAvail, avail, 0.001,
	@"checkAvailableBalanceDecrement: Expecting %0.2f, got %0.2f for available balance = %@",
							   expectedAvail,avail,bal.balanceName);
	
	[bal logBalance];
	
	STAssertEqualsWithAccuracy(bal.currentBalance, expectedBalAfter, 0.001,
		@"checkAvailableBalanceDecrement: Expecting %0.2f, got %0.2f for working balance = %@ after decrement",
							   expectedBalAfter,bal.currentBalance,bal.balanceName);
}


- (void)doZeroInterestTests:(WorkingBalance*)bal
{
	[self checkCurrentBalance:bal withExpectedBalance:1000];
	
	[bal incrementBalance:1000.0 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:bal withExpectedBalance:2000.0];

	[bal carryBalanceForward:[DateHelper dateFromStr:@"2013-01-01"]];
	[self checkCurrentBalance:bal withExpectedBalance:2000.0];

	[bal decrementAvailableBalance:500.0 asOfDate:[DateHelper dateFromStr:@"2013-05-01"]];
	[self checkCurrentBalance:bal withExpectedBalance:1500.0];
	
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

	[self checkCurrentBalance:bal withExpectedBalance:2000];

	[bal incrementBalance:1000.0 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:bal withExpectedBalance:3000];

	[bal decrementAvailableBalance:1000.0 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:bal withExpectedBalance:2000];
	
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
	
	CashWorkingBalance *cashBal = [[[CashWorkingBalance alloc] 
		initWithStartingBalance:startingBal 
		andStartDate:startDate] autorelease];
		
	NSDate *deferUntilDate = [DateHelper beginningOfDay:[DateHelper dateFromStr:@"2012-01-01"]];
	cashBal.deferWithdrawalsUntil = deferUntilDate;
	
	[cashBal decrementAvailableBalance:250.0 asOfDate:[DateHelper dateFromStr:@"2011-01-01"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:startingBal];

	[cashBal decrementAvailableBalance:250.0 asOfDate:[DateHelper dateFromStr:@"2011-07-01"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:startingBal];

	[cashBal decrementAvailableBalance:250.0 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:750.0];
	
	[cashBal carryBalanceForward:[DateHelper dateFromStr:@"2012-01-01"]];
	
	[cashBal decrementAvailableBalance:250.0 asOfDate:[DateHelper dateFromStr:@"2012-08-01"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:500.0];
	
	
	InterestBearingWorkingBalance *interestBal = [self 
		createInterestBearingWorkingAccountWithRate:0.0 andStartDate:startDate 
	andStartingBal:startingBal];
	interestBal.deferWithdrawalsUntil = deferUntilDate;
	
	[interestBal decrementAvailableBalance:250.0 asOfDate:[DateHelper dateFromStr:@"2011-01-01"]];
	[self checkCurrentBalance:interestBal withExpectedBalance:startingBal];

	[interestBal decrementAvailableBalance:250.0 asOfDate:[DateHelper dateFromStr:@"2011-07-01"]];
	[self checkCurrentBalance:interestBal withExpectedBalance:startingBal];
	
	[interestBal decrementAvailableBalance:250.0 asOfDate:[DateHelper dateFromStr:@"2011-12-31"]];
	[self checkCurrentBalance:interestBal withExpectedBalance:startingBal];

	[interestBal carryBalanceForward:[DateHelper dateFromStr:@"2012-01-01"]];


	[interestBal decrementAvailableBalance:250.0 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:interestBal withExpectedBalance:750.0];
	
	[interestBal decrementAvailableBalance:250.0 asOfDate:[DateHelper dateFromStr:@"2012-08-01"]];
	[self checkCurrentBalance:interestBal withExpectedBalance:500.0];

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
	
	double totalBal = [workingBalMgr totalCurrentNetBalance];
	STAssertEqualsWithAccuracy(totalBal, 1000.0, 0.001,
		@"testWorkingBalanceMgr: Expecting %0.2f, got %0.2f for total working balance",
							   1000.0,totalBal);

	
	[self checkCurrentBalance:cashBal withExpectedBalance:1000];
	[self checkCurrentBalance:deficitBal withExpectedBalance:0];
	
	[workingBalMgr incrementCashBalance:1000 asOfDate:[DateHelper dateFromStr:@"2012-01-01"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:2000];
	[self checkCurrentBalance:deficitBal withExpectedBalance:0];
	
	double decrementCashAmount = [workingBalMgr decrementAvailableCashBalance:1000 asOfDate:[DateHelper dateFromStr:@"2012-01-02"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:1000];
	[self checkCurrentBalance:deficitBal withExpectedBalance:0];
	STAssertEqualsWithAccuracy(decrementCashAmount, 1000.0, 0.001,
		@"testWorkingBalanceMgr: Expecting %0.2f, got %0.2f for decrement amount",
							   1000.0,decrementCashAmount);

	[workingBalMgr decrementAvailableCashBalance:1000 asOfDate:[DateHelper dateFromStr:@"2012-01-02"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:0];
	[self checkCurrentBalance:deficitBal withExpectedBalance:0];

	double decrementAmount = [workingBalMgr decrementBalanceFromFundingList:1000 
		asOfDate:[DateHelper dateFromStr:@"2012-01-02"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:0];
	[self checkCurrentBalance:deficitBal withExpectedBalance:1000];
	STAssertEqualsWithAccuracy(decrementAmount, 0.0, 0.001,
		@"testWorkingBalanceMgr: Expecting %0.2f, got %0.2f for decrement amount",
							   0.0,decrementAmount);
	
	[workingBalMgr incrementCashBalance:500 asOfDate:[DateHelper dateFromStr:@"2012-01-03"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:0];
	[self checkCurrentBalance:deficitBal withExpectedBalance:500];
	
	[workingBalMgr incrementCashBalance:1000 asOfDate:[DateHelper dateFromStr:@"2012-01-03"]];
	[self checkCurrentBalance:cashBal withExpectedBalance:500];
	[self checkCurrentBalance:deficitBal withExpectedBalance:0];



}

@end
