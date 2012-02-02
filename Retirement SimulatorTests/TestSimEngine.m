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
#import "AllTaxesPaidXYPlotDataGenerator.h"
#import "TaxesPaidXYPlotDataGenerator.h"
#import "TaxBracketEntry.h"
#import "TaxBracket.h"
#import "TaxInput.h"
#import "ItemizedTaxAmts.h"
#import "ItemizedTaxAmt.h"
#import "IncomeItemizedTaxAmt.h"
#import "ExpenseItemizedTaxAmt.h"

#import "Account.h"
#import "SavingsAccount.h"

#import "Cash.h"
#import "CashBalXYPlotDataGenerator.h"

#import "DeficitBalXYPlotDataGenerator.h"
#import "MultiScenarioAmount.h"
#import "MultiScenarioInputValue.h"
#import "FixedValue.h"
#import "InflationRate.h"
#import "UserScenario.h"
#import "AccountContribItemizedTaxAmt.h"
#import "AccountWithdrawalItemizedTaxAmt.h"

#import "NetWorthXYPlotDataGenerator.h"

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
	withAdjustedVals:(BOOL)checkAgainstInflationAdjustedVals
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
		double expectedVal = [yearVal.unadjustedVal doubleValue];
		 
		double resultVal;
		if(checkAgainstInflationAdjustedVals)
		{
			resultVal = [plotData getAdjustedYValforYear:year];
		}
		else
		{
			resultVal = [plotData getUnadjustedYValforYear:year];
		}
		
		NSLog(@"checkPlotData: %@: value for year=%d, expecting=%0.2f, got=%0.2f",label,year, expectedVal,resultVal);
		STAssertEqualsWithAccuracy(expectedVal, resultVal,0.01, 
			@"checkPlotData: %@: value for year=%d, expecting=%0.2f, got=%0.2f",
			label,year, expectedVal,resultVal);
		
	}

}

- (void)testExpenseWithoutInflationAdjustment {
        
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
	
	self.testAppVals.defaultInflationRate = (InflationRate*)
		[self.coreData createDataModelObject:INFLATION_RATE_ENTITY_NAME];
	self.testAppVals.defaultInflationRate.startingValue = [NSNumber numberWithDouble:10.0];
	self.testAppVals.defaultInflationRate.isDefault = [NSNumber numberWithBool:TRUE];
	self.testAppVals.defaultInflationRate.staticNameStringFileKey = @"DEFAULT_INFLATION_RATE_LABEL";
	self.testAppVals.defaultInflationRate.name = @"N/A";
    	
	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
//	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	ExpenseXYPlotDataGenerator *expenseData = [[[ExpenseXYPlotDataGenerator alloc] initWithExpense:expense01] autorelease];
	
	NSMutableArray *unadjustedExpected = [[[NSMutableArray alloc]init]autorelease];
	[unadjustedExpected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.00 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[unadjustedExpected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:110.02 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[unadjustedExpected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:121.03 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[unadjustedExpected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:133.13 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[unadjustedExpected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:146.44 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:expenseData withSimResults:simResults andExpectedVals:unadjustedExpected andLabel:@"expense01" withAdjustedVals:FALSE];

		
    NSLog(@"... Done testing sim engine");
    
}


- (void)testExpenseWithInflationAdjustment {
        
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
	
	self.testAppVals.defaultInflationRate = (InflationRate*)
		[self.coreData createDataModelObject:INFLATION_RATE_ENTITY_NAME];
	self.testAppVals.defaultInflationRate.startingValue = [NSNumber numberWithDouble:100.0];
	self.testAppVals.defaultInflationRate.isDefault = [NSNumber numberWithBool:TRUE];
	self.testAppVals.defaultInflationRate.staticNameStringFileKey = @"DEFAULT_INFLATION_RATE_LABEL";
	self.testAppVals.defaultInflationRate.name = @"N/A";
    	
	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-12-31"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	
	// Keep the expense's amount growth rate the same as the default inflation rate.
//	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	ExpenseXYPlotDataGenerator *expenseData = [[[ExpenseXYPlotDataGenerator alloc] initWithExpense:expense01] autorelease];
	
	
	NSMutableArray *adjustedExpected = [[[NSMutableArray alloc]init]autorelease];
	[adjustedExpected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[adjustedExpected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[adjustedExpected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[adjustedExpected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[adjustedExpected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];


	[self checkPlotData:expenseData withSimResults:simResults andExpectedVals:adjustedExpected andLabel:@"expense01" withAdjustedVals:TRUE];

		
    NSLog(@"... Done testing sim engine");
    
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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:expenseData withSimResults:simResults andExpectedVals:expected andLabel:@"expense01" withAdjustedVals:FALSE];

		
	AllExpenseXYPlotDataGenerator *allExpense = [[[AllExpenseXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];	
	[self checkPlotData:allExpense withSimResults:simResults andExpectedVals:expected andLabel:@"all expenses" withAdjustedVals:FALSE];
	
	
    
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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:expenseData withSimResults:simResults andExpectedVals:expected andLabel:@"expense01" withAdjustedVals:FALSE];

	self.testAppVals.currentInputScenario = userScen;
	[simResults runSimulatorForResults];

	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:expenseData withSimResults:simResults andExpectedVals:expected 
		andLabel:@"expense01 (alternate scenario)" withAdjustedVals:FALSE];

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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:incomeData withSimResults:simResults andExpectedVals:expected andLabel:@"income01" withAdjustedVals:FALSE];

		
	AllIncomeXYPlotDataGenerator *allIncome = [[[AllIncomeXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];	
	[self checkPlotData:allIncome withSimResults:simResults andExpectedVals:expected andLabel:@"all incomes" withAdjustedVals:FALSE];
	
	
	// The down payment should come out of cash funds
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:900.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];
	
	
    
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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];

	[self checkPlotData:assetData withSimResults:simResults andExpectedVals:expected andLabel:@"asset01" withAdjustedVals:FALSE];
	

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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:250.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:130.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:10.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];


	AllLoanBalanceXYPlotDataGenerator *allLoansData = [[[AllLoanBalanceXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:750.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:390.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:30.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];	
	
	[self checkPlotData:allLoansData withSimResults:simResults andExpectedVals:expected andLabel:@"all loans" withAdjustedVals:FALSE];
	
}


-(void)testLoanWithEarlyPayoff
{
	[self resetCoredData];

	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelInterface:self.coreData] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:600.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:60];	
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.earlyPayoffDate = [inputCreationHelper multiScenSimEndDateWithDefault:
			[DateHelper dateFromStr:@"2015-01-15"]];



	SimResultsController *simResults = [[[SimResultsController alloc] 
		initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:490.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:370.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:250.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];

	
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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:250.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:130.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:10.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];
	
	// The down payment should come out of cash funds
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:530.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:410.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:290.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:280.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:280.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];


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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:390.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:30.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];
	
	// The extra payment should come out of cash funds
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:670.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:310.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:280.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:280.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:280.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];


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
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];

	acct01.contribAmount = [inputCreationHelper multiScenAmountWithDefault:100.0];	
	acct01.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct01.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct01.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-20"]];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	// acct02 is identical to acct01, but is used to verify that summing up the account balances works properly.

	SavingsAccount *acct02 = (SavingsAccount*)[acctCreator createInput];
	acct02.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct02.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	acct02.contribAmount = [inputCreationHelper multiScenAmountWithDefault:100.0];	
	acct02.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct02.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct02.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-20"]];
	acct02.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctBalanceXYPlotDataGenerator *acctData = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];
	
	AllAcctBalanceXYPlotDataGenerator *allAcctData = [[[AllAcctBalanceXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:2200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:2400.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:2600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:2600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:2600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:allAcctData withSimResults:simResults andExpectedVals:expected andLabel:@"all accounts" withAdjustedVals:FALSE];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:800.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:400.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:400.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:400.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];

}

-(void)testAccountWithLimitedWithdrawalsSimple
{
	[self resetCoredData];
	
	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.name = @"expense01";
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelInterface:self.coreData] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:1.0];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	[acct01 addLimitWithdrawalExpensesObject:expense01];

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	// Withdrawals for expense01 should be permitted from acct01
	AcctBalanceXYPlotDataGenerator *acctData01 = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:900.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:800.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:700.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctData01 withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];	
	
}


-(void)testAccountWithLimitedWithdrawalsNonExpense
{
	[self resetCoredData];
	
	// This tests that non-expenses which require funding will 
	
	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.name = @"expense01";
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	AssetInputTypeSelectionInfo *assetCreator = 
		[[[AssetInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	AssetInput *asset01 = (AssetInput*)[assetCreator createInput];
	asset01.name = @"Asset01";
	asset01.cost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	asset01.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	asset01.purchaseDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-01-15"]];	
	asset01.saleDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-15"]];
	
	
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelInterface:self.coreData] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:1.0];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	[acct01 addLimitWithdrawalExpensesObject:expense01];

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	// Withdrawals for expense01 should be permitted from acct01
	AcctBalanceXYPlotDataGenerator *acctData01 = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:900.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:800.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:700.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctData01 withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];	
	
}


-(void)testAccountWithLimitedWithdrawals
{
	[self resetCoredData];
	
	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.name = @"expense01";
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInput *expense02 = (ExpenseInput*)[expenseCreator createInput];
	expense02.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	expense02.name = @"expense02";
	expense02.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense02.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense02.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelInterface:self.coreData] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:1.0];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	[acct01 addLimitWithdrawalExpensesObject:expense01];

	// acct02 is identical to acct01, but is used to verify that summing up the account balances works properly.

	SavingsAccount *acct02 = (SavingsAccount*)[acctCreator createInput];
	acct02.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct02.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:2.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct02.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	// Withdrawals for expense01 should be permitted from acct01
	AcctBalanceXYPlotDataGenerator *acctData01 = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:900.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:800.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:700.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctData01 withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];


	// Withdrawals for expense02 should come from the 2nd account, since the first is limited for expense01
	AcctBalanceXYPlotDataGenerator *acctData02 = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct02] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:800.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:400.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctData02 withSimResults:simResults andExpectedVals:expected andLabel:@"acct02" withAdjustedVals:FALSE];
	
	

}

-(void)testAccountWithDeferredWithdrawals
{
	[self resetCoredData];
	
	// In this test we check that deferred account withdrawals work. expense01 is setup to withdraw $100 each year.
	// Since acct01 has a higher priority than acct02, notwithstanding the deferred withdrawal date, the money
	// will come from acct01. Before the deferred withdrawal date, the money should come from acct02, then
	// after it will come from acct01.
	
	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.name = @"expense01";
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelInterface:self.coreData] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:1.0];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acct01.deferredWithdrawalsEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	acct01.deferredWithdrawalDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2014-1-01"]];


	[acct01 addLimitWithdrawalExpensesObject:expense01];

	// acct02 is identical to acct01, but is used to verify that summing up the account balances works properly.

	SavingsAccount *acct02 = (SavingsAccount*)[acctCreator createInput];
	acct02.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct02.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:2.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct02.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	// Withdrawals for expense01 should be permitted from acct01
	AcctBalanceXYPlotDataGenerator *acctData01 = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// Withdrawals don't occur from acct01 until 2014
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:900.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:800.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:700.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctData01 withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];


	// Withdrawals for expense02 should come from the 2nd account, since the first is limited for expense01
	AcctBalanceXYPlotDataGenerator *acctData02 = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct02] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:900.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:800.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// Starting in 2014, the withdrawals will come from acct01
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:800.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:800.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:800.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctData02 withSimResults:simResults andExpectedVals:expected andLabel:@"acct02" withAdjustedVals:FALSE];
	
	

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
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	acct01.contribAmount = [inputCreationHelper multiScenAmountWithDefault:100.0];	
	acct01.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct01.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct01.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-20"]];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	SavingsAccount *acct02 = (SavingsAccount*)[acctCreator createInput];
	acct02.name = @"Acct02";
	acct02.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct02.contribAmount = [inputCreationHelper multiScenAmountWithDefault:200.0];	
	acct02.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	acct02.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct02.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct02.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-20"]];
	acct02.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctContribXYPlotGenerator *acctContribData = [[[AcctContribXYPlotGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctContribData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];
	
	AllAcctContribXYPlotDataGenerator *allAcctContribData = [[[AllAcctContribXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:allAcctContribData withSimResults:simResults andExpectedVals:expected andLabel:@"all accounts" withAdjustedVals:FALSE];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1700.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1400.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:900.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:900.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];

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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctWithdrawalData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];
	
	AllAcctContribXYPlotDataGenerator *allAcctWithdrawalData = [[[AllAcctWithdrawalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:allAcctWithdrawalData withSimResults:simResults andExpectedVals:expected andLabel:@"all accounts" withAdjustedVals:FALSE];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];

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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];

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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1400.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];

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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];

	DeficitBalXYPlotDataGenerator *deficitData= [[[DeficitBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:600.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1400.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];

	[self checkPlotData:deficitData withSimResults:simResults andExpectedVals:expected andLabel:@"deficit balances" withAdjustedVals:FALSE];

	
}


- (void)testFlatTax {
        
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


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];

	
	TaxInput *secondTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *secondTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	secondTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	secondTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[secondTax.taxBracket addTaxBracketEntriesObject:secondTaxEntry];
	
	IncomeItemizedTaxAmt *itemizedIncome02 = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome02.income = income02;
	itemizedIncome02.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[secondTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome02];
	
	
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	IncomeXYPlotDataGenerator *incomeData = [[[IncomeXYPlotDataGenerator alloc] initWithIncome:income01] autorelease];


	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:incomeData withSimResults:simResults andExpectedVals:expected andLabel:@"income01" withAdjustedVals:FALSE];

	
	AllTaxesPaidXYPlotDataGenerator *allTaxData = [[[AllTaxesPaidXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:75.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:75.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:75.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:75.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:75.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:allTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"all taxes" withAdjustedVals:FALSE];
	
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"flatTax" withAdjustedVals:FALSE];
	
    
    NSLog(@"... Done testing sim engine");
    
     
}


- (void)testStdDeduction {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
    	
		
	// The yearly income is 200, but the standard deduction is 100. This leaves a taxable income of
	// 100 which is taxed at 25%. This means there should be $25 taxes paid each year.	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	flatTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:100.0];
	flatTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];
	
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData 
		andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	

	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"standard deduction" withAdjustedVals:FALSE];
	
    
    NSLog(@"... Done testing sim engine");
    
     
}

- (void)testItemizedDeduction {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
    	
		
	// The yearly income is 200, but the standard deduction is 100. This leaves a taxable income of
	// 100 which is taxed at 25%. This means there should be $25 taxes paid each year.	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:150.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:50.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	flatTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:0.0];
	flatTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];
	
	ExpenseItemizedTaxAmt *itemizedExpenseDeduction = [self.coreData insertObject:EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedExpenseDeduction.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedExpenseDeduction.expense = expense01;
	[flatTax.itemizedDeductions addItemizedAmtsObject:itemizedExpenseDeduction];
	
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData 
		andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	

	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"itemized deduction" withAdjustedVals:FALSE];
	
    
    NSLog(@"... Done testing sim engine");
    
     
}


- (void)testItemizedDeductionDisabledExpense {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
    	
		
	// In this test, there is an itemized deduction, but it is disabled. Therefore, we expect the disabled 
	// expense to have no impact on the taxation; i.e. the full $100 should be taxed at 25% rather
	// than the $50.	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:50.0];
	expense01.cashFlowEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	flatTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:0.0];
	flatTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];
	
	ExpenseItemizedTaxAmt *itemizedExpenseDeduction = [self.coreData insertObject:EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedExpenseDeduction.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedExpenseDeduction.expense = expense01;
	[flatTax.itemizedDeductions addItemizedAmtsObject:itemizedExpenseDeduction];
	
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData 
		andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	

	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"itemized deduction" withAdjustedVals:FALSE];
	
	
	// re-enabling the expense should result in it's itemized deduction also being re-enabled. After the 
	// deduction, the tax should be 25% of $50, whith is $12.50.
	expense01.cashFlowEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];

	[simResults runSimulatorForResults];

	expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:12.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:12.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:12.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:12.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:12.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"itemized deduction" withAdjustedVals:FALSE];
    
    NSLog(@"... Done testing sim engine");
    
     
}

- (void)testItemizedDeductionNoTax {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
 
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];
   	
		
	// In this test, there is both an income and expense of $100. In the first run of the simulator, the 
	// deduction is not applied, so the tax should be $25/year. After adding the deduction, the taxes
	// paid should go to zero. We also test the impact on net worth, whereby without the deduction,
	// the net worth goes down by $25.00 each year, but stays the same with the deduction.
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	flatTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:0.0];
	flatTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];
	
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData 
		andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	

	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"itemized deduction - no tax (w/out deduction)" withAdjustedVals:FALSE];
	
	
	NetWorthXYPlotDataGenerator *netWorthData = [[[NetWorthXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:975.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:950.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:925.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:900.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:875.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:netWorthData withSimResults:simResults andExpectedVals:expected andLabel:@"itemized deduction - no tax (w/out deduction)" withAdjustedVals:FALSE];

	ExpenseItemizedTaxAmt *itemizedExpenseDeduction = [self.coreData insertObject:EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedExpenseDeduction.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedExpenseDeduction.expense = expense01;
	[flatTax.itemizedDeductions addItemizedAmtsObject:itemizedExpenseDeduction];
	
	// Rerun the simulator. This time the decution of $100/year is applicable.
	[simResults runSimulatorForResults];
	
	expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"itemized deduction - no tax" withAdjustedVals:FALSE];	
	
	
	// Since no tax is being paid, the net worth should remain at 1000
	expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:netWorthData withSimResults:simResults andExpectedVals:expected andLabel:@"itemized deduction - no tax (w/out deduction)" withAdjustedVals:FALSE];
	
    NSLog(@"... Done testing sim engine");
    
     
}

- (void)testPartialTax {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
	
	// In this test, the yearly income is $200, but only 50% of it is taxed at a 25% tax rate
    	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:50.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
		
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"flatTax" withAdjustedVals:FALSE];
	
    
    NSLog(@"... Done testing sim engine");
    
     
}

- (void)testTaxBracket {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
	
	// In this test, the first $100 is taxed at 25%, but anything above that is taxed at 50%
    	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:100.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:50.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	
	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];

		
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
		
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:75.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:75.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:75.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:75.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:75.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"bracketed tax" withAdjustedVals:FALSE];
	
    
    NSLog(@"... Done testing sim engine");
    
     
}

- (void)testTaxCredit {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
		
	// In this test the yearly income is $100, which is taxed at 25%. There is also a tax credit of $10,
	// which directly reduces the tax liability (taxes paid) by another $10. This should result in a taxes
	// paid of $15 each year.	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:10.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	flatTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:0.0];
	flatTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];
	
	ExpenseItemizedTaxAmt *itemizedExpenseDeduction = [self.coreData insertObject:EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedExpenseDeduction.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedExpenseDeduction.expense = expense01;
	[flatTax.itemizedCredits addItemizedAmtsObject:itemizedExpenseDeduction];
	
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData 
		andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	

	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:15.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:15.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:15.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:15.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:15.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"itemized deduction" withAdjustedVals:FALSE];
	
    
    NSLog(@"... Done testing sim engine");
    
     
}

- (void)testTaxAdjustment {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
		
	// In this test the yearly income is $200, which is taxed at 25%. There is also a tax adjustment of $100,
	// This should result in a taxes paid of $25 each year.	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	flatTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:0.0];
	flatTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];
	
	ExpenseItemizedTaxAmt *itemizedExpenseDeduction = [self.coreData insertObject:EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedExpenseDeduction.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedExpenseDeduction.expense = expense01;
	[flatTax.itemizedAdjustments addItemizedAmtsObject:itemizedExpenseDeduction];
	
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData 
		andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	

	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"itemized deduction" withAdjustedVals:FALSE];
	
    
    NSLog(@"... Done testing sim engine");
    
     
}



- (void)testTaxExemption {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
    	
		
	// The yearly income is 200, but there is an exemption of 100. This leaves a taxable income of
	// 100 which is taxed at 25%. This means there should be $25 taxes paid each year.	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	flatTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:0.0];
	flatTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	flatTax.exemptionAmt = [self.inputCreationHelper multiScenAmountWithDefault:100.0];
	flatTax.exemptionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];
	
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData 
		andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	

	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"standard deduction" withAdjustedVals:FALSE];
	
    
    NSLog(@"... Done testing sim engine");
    
     
}


-(void)testTaxableAccountWithdraw
{
	[self resetCoredData];
	
	
	// In this test there is an expense of $100/year. This expense triggers a withdrawal
	// from acct01, which is itemized a tax source for a tax of 25%.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
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


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	flatTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:0.0];
	flatTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	AccountWithdrawalItemizedTaxAmt *taxableWithdrawal = [self.coreData insertObject:ACCOUNT_WITHDRAWAL_ITEMIZED_TAX_AMT_ENTITY_NAME]; 
	taxableWithdrawal.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	taxableWithdrawal.account  = acct01;
	
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:taxableWithdrawal];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctWithdrawalXYPlotDataGenerator *acctWithdrawalData = [[[AcctWithdrawalXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
//	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
//	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
//	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
//	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctWithdrawalData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01 withdrawals" withAdjustedVals:FALSE];
	
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"taxable withdrawals" withAdjustedVals:FALSE];

}

-(void)testDeductableContribution
{
	[self resetCoredData];
	
	
	// In this test there is income of $200/year, which is taxed at 25%. However, there is also a $100 tax deductable
	// contribution to acct01, which reduces that tax liability to $100. Of the remaining $100, $25 tax should be paid.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];

	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelInterface:self.coreData] autorelease];
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:1.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acct01.contribGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acct01.contribAmount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	acct01.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	acct01.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
	acct01.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelInterface:self.coreData] autorelease];
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	flatTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:0.0];
	flatTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	AccountContribItemizedTaxAmt *deductableWithdrawal = [self.coreData insertObject:ACCOUNT_CONTRIB_ITEMIZED_TAX_AMT_ENTITY_NAME];
	deductableWithdrawal.account = acct01;
	deductableWithdrawal.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];	
	[flatTax.itemizedDeductions addItemizedAmtsObject:deductableWithdrawal];

	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
		
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"deductable contribs" withAdjustedVals:FALSE];

}


@end
