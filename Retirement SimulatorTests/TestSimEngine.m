//
//  TestSimEngine.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// TODO - Additional tests needed, include (but not limited to):
//     - Stream of multiple events
//     - Event and results happen on same date
//     - Multiple results between events
//     - Multiple events between results

#import "SimEngine.h"

#import "TestSimEngine.h"
#import "TestSimEventCreator.h"
#import "DataModelController.h"
#import "SharedAppValues.h"
#import "InputCreationHelper.h"
#import "RelativeEndDate.h"
#import "DateHelper.h"
#import "InputTypeSelectionInfo.h"

#import "ExpenseInput.h"
#import "SimResultsController.h"
#import "ExpenseXYPlotDataGenerator.h"
#import "AllExpenseXYPlotDataGenerator.h"
#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "YearValPlotDataVal.h"

#import "IncomeInput.h"
#import "IncomeXYPlotDataGenerator.h"
#import "AllIncomeXYPlotDataGenerator.h"

#import "AssetInput.h"
#import "AssetValueXYPlotDataGenerator.h"
#import "AllAssetValueXYPlotDataGenerator.h"

#import "LoanInput.h"
#import "LoanBalXYPlotDataGenerator.h"
#import "AllLoanBalanceXYPlotDataGenerator.h"

#import "AcctBalanceXYPlotDataGenerator.h"
#import "AllAcctBalanceXYPlotDataGenerator.h"
#import "AcctContribXYPlotGenerator.h"
#import "AllAcctContribXYPlotDataGenerator.h"
#import "AllAcctWithdrawalXYPlotDataGenerator.h"
#import "AcctWithdrawalXYPlotDataGenerator.h"


#import "Account.h"
#import "SavingsAccount.h"

#import "Cash.h"
#import "CashBalXYPlotDataGenerator.h"

#import "DeficitBalXYPlotDataGenerator.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioInputValue.h"
#import "FixedValue.h"
#import "UserScenario.h"

@implementation TestSimEngine

@synthesize coreData;
@synthesize testAppVals;
@synthesize inputCreationHelper;

- (void)resetCoredData
{
	self.coreData = [[[DataModelController alloc] initForInMemoryStorage] autorelease];
	self.testAppVals = [SharedAppValues createWithDataModelInterface:self.coreData];
	
	self.testAppVals.simStartDate = [DateHelper dateFromStr:@"2012-01-01"];
	
	// For testing purposes, default to 5 years (instead of 50). By setting the sim end date to 59
	// weeks, the simulator will round up to 5 years (instead of rounding up to 6 years).
	RelativeEndDate *theSimEndDate = [self.coreData createDataModelObject:RELATIVE_END_DATE_ENTITY_NAME];
	theSimEndDate.monthsOffset = [NSNumber numberWithInt:59];
	self.testAppVals.simEndDate = theSimEndDate;
	
	self.inputCreationHelper = [[[InputCreationHelper alloc] 
		initWithDataModelInterface:self.coreData
		andSharedAppVals:self.testAppVals] autorelease];
}

- (void)setUp
{
	[self resetCoredData];
}

- (void)tearDown
{
	[coreData release];
	[testAppVals release];
	[inputCreationHelper release];
}

-(void)checkPlotData:(id<YearValXYPlotDataGenerator>)plotDataGen withSimResults:(SimResultsController*)simResults
	andExpectedVals:(NSArray*)expectedVals
	andLabel:(NSString*)label
{
	assert(simResults != nil);
	assert(plotDataGen != nil);
	assert(label != nil);
	
	STAssertTrue([plotDataGen resultsDefinedInSimResults:simResults],
		@"Expecting results to be defined for: %@",label);
		
	YearValXYPlotData *plotData = [plotDataGen generatePlotDataFromSimResults:simResults];
		
	for(YearValPlotDataVal *yearVal in expectedVals)
	{
		NSInteger year = [yearVal.year integerValue];
		double expectedVal = [yearVal.val doubleValue];
		
		double resultVal = [plotData getYValforYear:year];
		
		NSLog(@"checkPlotData: %@: value for year=%d, expecting=%0.2f, got=%0.2f",label,year, expectedVal,resultVal);
		STAssertEqualsWithAccuracy(expectedVal, resultVal,0.01, 
			@"checkPlotData: %@: value for year=%d, expecting=%0.2f, got=%0.2f",
			label,year, expectedVal,resultVal);
		
	}

}


- (void)testExpense {
        
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
    	
	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInput *expense02 = (ExpenseInput*)[expenseCreator createInput];
	expense02.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	expense02.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-20"]];
	expense02.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense02.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	ExpenseXYPlotDataGenerator *expenseData = [[[ExpenseXYPlotDataGenerator alloc] initWithExpense:expense01] autorelease];
	
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:100.0] autorelease]];
	
	[self checkPlotData:expenseData withSimResults:simResults andExpectedVals:expected andLabel:@"expense01"];

		
	AllExpenseXYPlotDataGenerator *allExpense = [[[AllExpenseXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:300.0] autorelease]];	
	[self checkPlotData:allExpense withSimResults:simResults andExpectedVals:expected andLabel:@"all expenses"];
	
	
    
    NSLog(@"... Done testing sim engine");
    
     
}

-(void)testExpenseWithScenario
{
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
    	
	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	UserScenario *userScen = [self.coreData insertObject:USER_SCENARIO_ENTITY_NAME];
	userScen.name = @"Alternate Scenario";
	

	[expense01.amount.amount setValueForScenario:userScen 
		andInputValue:[self.inputCreationHelper fixedValueForValue:300.0]];

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	ExpenseXYPlotDataGenerator *expenseData = [[[ExpenseXYPlotDataGenerator alloc] initWithExpense:expense01] autorelease];
	
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:100.0] autorelease]];
	
	[self checkPlotData:expenseData withSimResults:simResults andExpectedVals:expected andLabel:@"expense01"];

	self.testAppVals.currentInputScenario = userScen;
	[simResults runSimulatorForResults];

	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:300.0] autorelease]];
	
	[self checkPlotData:expenseData withSimResults:simResults andExpectedVals:expected 
		andLabel:@"expense01 (alternate scenario)"];

}


- (void)testIncome {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
    	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	IncomeInput *income02 = (IncomeInput*)[incomeCreator createInput];
	income02.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income02.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-20"]];
	income02.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income02.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	IncomeXYPlotDataGenerator *incomeData = [[[IncomeXYPlotDataGenerator alloc] initWithIncome:income01] autorelease];


	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:100.0] autorelease]];
	
	[self checkPlotData:incomeData withSimResults:simResults andExpectedVals:expected andLabel:@"income01"];

		
	AllIncomeXYPlotDataGenerator *allIncome = [[[AllIncomeXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:300.0] autorelease]];	
	[self checkPlotData:allIncome withSimResults:simResults andExpectedVals:expected andLabel:@"all incomes"];
	
	
	// The down payment should come out of cash funds
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:600.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:900.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1200.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1500.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances"];
	
	
    
    NSLog(@"... Done testing sim engine");
    
     
}

-(void)testAsset
{
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
    	
	AssetInputTypeSelectionInfo *assetCreator = 
		[[[AssetInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	AssetInput *asset01 = (AssetInput*)[assetCreator createInput];
	asset01.cost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	asset01.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	asset01.purchaseDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-01-15"]];	
	asset01.saleDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-15"]];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];

	AssetValueXYPlotDataGenerator *assetData = [[[AssetValueXYPlotDataGenerator alloc] initWithAsset:asset01]autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1000.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1000.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];

	[self checkPlotData:assetData withSimResults:simResults andExpectedVals:expected andLabel:@"asset01"];
	

}


-(void)testLoan
{
	[self resetCoredData];

	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelInterface:self.coreData] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:360.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];	
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	LoanInput *loan02 = (LoanInput*)[loanCreator createInput];
	loan02.loanCost = [inputCreationHelper multiScenAmountWithDefault:720.0];
	loan02.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];	
	loan02.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan02.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	loan02.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:250.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:130.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:10.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01"];


	AllLoanBalanceXYPlotDataGenerator *allLoansData = [[[AllLoanBalanceXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:750.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:390.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:30.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];	
	
	[self checkPlotData:allLoansData withSimResults:simResults andExpectedVals:expected andLabel:@"all loans"];
	
}

-(void)testLoanWithDownPayment
{

	[self resetCoredData];
	
		self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelInterface:self.coreData] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:720.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];	
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	loan01.downPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	loan01.multiScenarioDownPmtPercentFixed = [inputCreationHelper multiScenFixedValWithDefault:50.0];
	loan01.multiScenarioDownPmtPercent = [inputCreationHelper multiScenInputValueWithDefaultFixedVal:
		loan01.multiScenarioDownPmtPercentFixed];
	


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:250.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:130.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:10.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01"];
	
	// The down payment should come out of cash funds
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:530.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:410.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:290.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:280.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:280.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances"];


}


-(void)testLoanWithExtraPayments
{

	[self resetCoredData];
	
		self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelInterface:self.coreData] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:720.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];	
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	loan01.extraPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.extraPmtAmt = [inputCreationHelper multiScenAmountWithDefault:10.0];
	loan01.extraPmtGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	// TBD - extraPmtFrequency doesn't 
	// have any UI input - Should this change
	loan01.extraPmtFrequency = [inputCreationHelper multiScenarioRepeatFrequencyMonthly];
	


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:390.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:30.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01"];
	
	// The extra payment should come out of cash funds
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:670.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:310.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:280.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:280.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:280.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances"];


}



-(void)testAccount
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelInterface:self.coreData] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribAmount = [inputCreationHelper multiScenAmountWithDefault:100.0];	
	acct01.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct01.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct01.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-20"]];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	// acct02 is identical to acct01, but is used to verify that summing up the account balances works properly.

	SavingsAccount *acct02 = (SavingsAccount*)[acctCreator createInput];
	acct02.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct02.contribAmount = [inputCreationHelper multiScenAmountWithDefault:100.0];	
	acct02.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct02.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct02.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-20"]];
	acct02.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctBalanceXYPlotDataGenerator *acctData = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1200.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1300.0] autorelease]];
	
	[self checkPlotData:acctData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01"];
	
	AllAcctBalanceXYPlotDataGenerator *allAcctData = [[[AllAcctBalanceXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:2200.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:2400.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:2600.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:2600.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:2600.0] autorelease]];
	
	[self checkPlotData:allAcctData withSimResults:simResults andExpectedVals:expected andLabel:@"all accounts"];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:800.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:600.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:400.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:400.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:400.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances"];

}



-(void)testAccountContrib
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelInterface:self.coreData] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:2000.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribAmount = [inputCreationHelper multiScenAmountWithDefault:100.0];	
	acct01.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct01.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct01.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-20"]];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	SavingsAccount *acct02 = (SavingsAccount*)[acctCreator createInput];
	acct02.name = @"Acct02";
	acct02.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct02.contribAmount = [inputCreationHelper multiScenAmountWithDefault:200.0];	
	acct02.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct02.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct02.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-20"]];
	acct02.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctContribXYPlotGenerator *acctContribData = [[[AcctContribXYPlotGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];
	
	[self checkPlotData:acctContribData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01"];
	
	AllAcctContribXYPlotDataGenerator *allAcctContribData = [[[AllAcctContribXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:200.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];
	
	[self checkPlotData:allAcctContribData withSimResults:simResults andExpectedVals:expected andLabel:@"all accounts"];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1700.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1400.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:900.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:900.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances"];

}

-(void)testAccountWithdraw
{
	[self resetCoredData];
	
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:500.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:500.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelInterface:self.coreData] autorelease];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:1.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	SavingsAccount *acct02 = (SavingsAccount*)[acctCreator createInput];
	acct02.name = @"Acct02";
	acct02.startingBalance = [NSNumber numberWithDouble:700.0];
	acct02.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:2.0];
	acct02.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct02.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctContribXYPlotGenerator *acctWithdrawalData = [[[AcctWithdrawalXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:500.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:500.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];
	
	[self checkPlotData:acctWithdrawalData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01"];
	
	AllAcctContribXYPlotDataGenerator *allAcctWithdrawalData = [[[AllAcctWithdrawalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:500.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:500.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:500.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:200.0] autorelease]];
	
	[self checkPlotData:allAcctWithdrawalData withSimResults:simResults andExpectedVals:expected andLabel:@"all accounts"];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances"];

}



-(void)testCashBalWithExpense
{
	[self resetCoredData];

	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];


	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:400.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:600.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:200.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances"];

}

-(void)testCashBalWithIncome
{
	[self resetCoredData];

	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];

	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1100.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1200.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1300.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1400.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances"];

}

-(void)testDeficit
{

	[self resetCoredData];

	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:600.0];
	
	self.testAppVals.deficitInterestRate = [inputCreationHelper fixedValueForValue:0.0];


	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:400.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:200.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances"];

	DeficitBalXYPlotDataGenerator *deficitData= [[[DeficitBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:200.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:600.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1400.0] autorelease]];

	[self checkPlotData:deficitData withSimResults:simResults andExpectedVals:expected andLabel:@"deficit balances"];

	
}

@end
