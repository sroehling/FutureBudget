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
#import "AssetGainItemizedTaxAmt.h"

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
#import "TaxesPaidItemizedTaxAmt.h"
#import "AccountInterestItemizedTaxAmt.h"

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
#import "TransferInput.h"
#import "TransferEndpointAcct.h"
#import "TransferEndpointCash.h"
#import "TaxInputTypeSelectionInfo.h"

#import "AcctDividendXYPlotDataGenerator.h"
#import "AcctCapitalGainsXYPlotDataGenerator.h"
#import "AcctCapitalLossXYPlotDataGenerator.h"
#import "AccountCapitalGainItemizedTaxAmt.h"
#import "AccountCapitalLossItemizedTaxAmt.h"

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
		initWithDataModelController:self.coreData
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
		STAssertEqualsWithAccuracy(resultVal,expectedVal,0.01, 
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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

- (void)testIncomeWithInflationAdjustment {
        
 	[self resetCoredData];
   
    NSLog(@"Starting test: testIncomeWithInflationAdjustment ...");
	
	// Inflation rate is the same as the growth rate of the income. They should cancel each other
	// out, so that the inflation adjusted income is 100.0.
	CGFloat kInflationRate = 100.0;
	NSString *incomeStartDate = @"2012-1-01";
	BOOL doAdjustForInflation = TRUE;
		
	self.testAppVals.defaultInflationRate = (InflationRate*)
		[self.coreData createDataModelObject:INFLATION_RATE_ENTITY_NAME];
	self.testAppVals.defaultInflationRate.startingValue = [NSNumber numberWithDouble:kInflationRate];
	self.testAppVals.defaultInflationRate.isDefault = [NSNumber numberWithBool:TRUE];
	self.testAppVals.defaultInflationRate.staticNameStringFileKey = @"DEFAULT_INFLATION_RATE_LABEL";
	self.testAppVals.defaultInflationRate.name = @"N/A";

    	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:incomeStartDate]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:kInflationRate];

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	IncomeXYPlotDataGenerator *incomeData = [[[IncomeXYPlotDataGenerator alloc] initWithIncome:income01] autorelease];

	// With the artificial/contrived inflation rate of 100%, the value of the income will drop 50% each
	// year. The inflation adjusted value is taken at the end of the year. So, if the income occurs at
	// beginning of the year, it's inflation adjusted value will be roughly half by the end of the year.
	//
	// This behavior can be confusing when the inflation adjusted results are displayed in the app, but
	// it is nonetheless consistent.


	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:50.00 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:50.10 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:50.09 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:incomeData withSimResults:simResults andExpectedVals:expected andLabel:@"income01" withAdjustedVals:doAdjustForInflation];

		
    NSLog(@"... Done testing: testIncomeWithInflationAdjustment");
    
     
}


-(void)testAsset
{
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
    	
	AssetInputTypeSelectionInfo *assetCreator = 
		[[[AssetInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	AssetInput *asset01 = (AssetInput*)[assetCreator createInput];
	asset01.cost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	asset01.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];

	asset01.purchaseDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-01-01"]];
	asset01.saleDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-01"]];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];

	AssetValueXYPlotDataGenerator *assetData = [[[AssetValueXYPlotDataGenerator alloc] initWithAsset:asset01]autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1210 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1331 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];

	[self checkPlotData:assetData withSimResults:simResults andExpectedVals:expected andLabel:@"asset01" withAdjustedVals:FALSE];
	
	// Asset should be included in net worth calculations
	// In this case, since the asset was purchased after the start of simulation,
	// the cost to purchase the asset comes from the cash balance. So, the net worth
	// only appreciates by the asset appreciation, because the original purchase price
	// has already been deducted from the cash balance (and added to the deficit balance).
	NetWorthXYPlotDataGenerator *netWorthData = [[[NetWorthXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:109.71 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:230.71 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:231.06 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:231.06 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:netWorthData withSimResults:simResults andExpectedVals:expected andLabel:@"Net worth with asset" withAdjustedVals:FALSE];

}


-(void)testAssetPurchasedBeforeSimStart
{
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
    	
	AssetInputTypeSelectionInfo *assetCreator = 
		[[[AssetInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	AssetInput *asset01 = (AssetInput*)[assetCreator createInput];
	asset01.cost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	asset01.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];

	asset01.purchaseDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2011-01-01"]];
	asset01.saleDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-01"]];
	
	// If the asset purchase date is before the simulation start, 'startingValue' is
	// used as a baseline value to use as te asset's value going into the simulation.
	asset01.startingValue = [NSNumber numberWithDouble:1000.0];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];

	AssetValueXYPlotDataGenerator *assetData = [[[AssetValueXYPlotDataGenerator alloc] initWithAsset:asset01]autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1100 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1210 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1331 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];

	[self checkPlotData:assetData withSimResults:simResults andExpectedVals:expected andLabel:@"asset01" withAdjustedVals:FALSE];
	
	// Asset should be included in net worth calculations
	// In this case, since the asset was purchased before the start of simulation, the
	// total asset price should be included.
	NetWorthXYPlotDataGenerator *netWorthData = [[[NetWorthXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1100
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1210 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1331 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	// Since the asset it sold on 2015-01-01, there is one extra day of interest for the $0.34.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1331.34 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	// Even after the asset is sold, the net worth should remain the same, since the sale
	// of the asset goes into the cash balance.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1331.34 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:netWorthData withSimResults:simResults andExpectedVals:expected andLabel:@"Net worth with asset" withAdjustedVals:FALSE];

}



-(void)testFutureAsset
{
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
    	
	AssetInputTypeSelectionInfo *assetCreator = 
		[[[AssetInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	AssetInput *asset01 = (AssetInput*)[assetCreator createInput];
	asset01.cost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	asset01.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];

	asset01.purchaseDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2014-01-02"]];	
	asset01.saleDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2016-01-02"]];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];

	AssetValueXYPlotDataGenerator *assetData = [[[AssetValueXYPlotDataGenerator alloc] initWithAsset:asset01]autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1331 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1464.1 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];

	[self checkPlotData:assetData withSimResults:simResults andExpectedVals:expected andLabel:@"asset01" withAdjustedVals:FALSE];
	

}


-(void)testAssetStartingVal
{
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
    	
	AssetInputTypeSelectionInfo *assetCreator = 
		[[[AssetInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	AssetInput *asset01 = (AssetInput*)[assetCreator createInput];
	asset01.cost = [inputCreationHelper multiScenAmountWithDefault:2000.0];
	asset01.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	asset01.purchaseDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2011-01-15"]];	
	asset01.saleDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-15"]];
	// If the asset is purchased before the simulation start date of 2012-01-01, then the asset value
	// should take on it's starting value.
	asset01.startingValue = [NSNumber numberWithDouble:10000];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];

	AssetValueXYPlotDataGenerator *assetData = [[[AssetValueXYPlotDataGenerator alloc] initWithAsset:asset01]autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:10000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:10000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:10000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];

	[self checkPlotData:assetData withSimResults:simResults andExpectedVals:expected andLabel:@"asset01" withAdjustedVals:FALSE];
	

}

-(void)testDepreciatingAsset
{
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
    	
	AssetInputTypeSelectionInfo *assetCreator = 
		[[[AssetInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	AssetInput *asset01 = (AssetInput*)[assetCreator createInput];
	asset01.cost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	asset01.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:-10.0];

	asset01.purchaseDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-01"]];
	asset01.saleDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-01"]];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];

	AssetValueXYPlotDataGenerator *assetData = [[[AssetValueXYPlotDataGenerator alloc] initWithAsset:asset01]autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:900 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:810 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:729 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];

	[self checkPlotData:assetData withSimResults:simResults andExpectedVals:expected andLabel:@"asset01" withAdjustedVals:FALSE];
	
	


}


-(void)testAssetAppreciationWithTaxes
{
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
    	
	AssetInputTypeSelectionInfo *assetCreator = 
		[[[AssetInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	AssetInput *asset01 = (AssetInput*)[assetCreator createInput];
	asset01.cost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	asset01.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];

	asset01.purchaseDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-01"]];
	asset01.saleDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-01"]];
	
	
	TaxInputTypeSelectionInfo *taxCreator = 
	[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
	andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	AssetGainItemizedTaxAmt *itemizedAssetGain = [self.coreData insertObject:ASSET_GAIN_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedAssetGain.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedAssetGain.asset  = asset01;
		
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedAssetGain];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];

	AssetValueXYPlotDataGenerator *assetData = [[[AssetValueXYPlotDataGenerator alloc] initWithAsset:asset01]autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1100 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1210 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1331 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];

	[self checkPlotData:assetData withSimResults:simResults andExpectedVals:expected andLabel:@"asset01" withAdjustedVals:FALSE];
	
	
			TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:82.83 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"flatTax" withAdjustedVals:FALSE];


}



-(void)testAssetDepreciationWithTaxes
{
	[self resetCoredData];
    
    NSLog(@"Starting sim engine test ...");
    	
	AssetInputTypeSelectionInfo *assetCreator = 
		[[[AssetInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	AssetInput *asset01 = (AssetInput*)[assetCreator createInput];
	asset01.cost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	asset01.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:-10.0];

	asset01.purchaseDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-01"]];
	asset01.saleDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-01"]];
	
	
	TaxInputTypeSelectionInfo *taxCreator = 
	[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
	andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	AssetGainItemizedTaxAmt *itemizedAssetGain = [self.coreData insertObject:ASSET_GAIN_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedAssetGain.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedAssetGain.asset  = asset01;
		
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedAssetGain];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];

	AssetValueXYPlotDataGenerator *assetData = [[[AssetValueXYPlotDataGenerator alloc] initWithAsset:asset01]autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:900 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:810 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:729 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];

	[self checkPlotData:assetData withSimResults:simResults andExpectedVals:expected andLabel:@"asset01" withAdjustedVals:FALSE];
	
	
			TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"flatTax" withAdjustedVals:FALSE];


}



-(void)testLoan
{
	[self resetCoredData];

	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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


-(void)testLoanCashBal
{
	[self resetCoredData];

	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:360.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];	
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];



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
	

	// The cash balance starts at 0, but with the loan origination is credited with 360. The cash balance is then drawn down to pay for the
	// loan.
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1250.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1130.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1010.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];


	NetWorthXYPlotDataGenerator *netWorthData = [[[NetWorthXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:netWorthData withSimResults:simResults andExpectedVals:expected andLabel:@"Net worth" withAdjustedVals:FALSE];


}





-(void)testLoanWithEarlyPayoff
{
	[self resetCoredData];

	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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


-(void)testLoanWithEarlyPayoffAndProratedInterest
{
	[self resetCoredData];

	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:10000.0];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests.
	// These results have been cross-checked against spreadsheet calculations in:
	// MonthlyMortgageInterestCalculation.xlsx

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:10000.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	// Use a high interest rate, so the prorated interest amount is easily discerned.
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:12.0];
	loan01.earlyPayoffDate = [inputCreationHelper multiScenSimEndDateWithDefault:
			[DateHelper dateFromStr:@"2014-01-01"]];



	SimResultsController *simResults = [[[SimResultsController alloc] 
		initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:7314.84 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:4030.14 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:16346.43 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:12360.71 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:8308.10 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:8308.10 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:8308.10 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];

	
}

-(void)testLoanWithEarlyPayoffAndProratedInterestEndOfMonth
{
	[self resetCoredData];

	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:10000.0];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests.
	// These results have been cross-checked against spreadsheet calculations in:
	// MonthlyMortgageInterestCalculation.xlsx

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:10000.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	// Use a high interest rate, so the prorated interest amount is easily discerned.
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:12.0];
	
	// The payoff happens right before the regular payment on 06/15, so the the amount of interest should
	// be almost the entire amount for the month. This test is almost identical to the testLoanWithEarlyPayoffAndProratedInterest,
	// but the payment happens in the middle of the year, which also further tests the logic for advancing the
	// start date for prorated interest calculation (within the PeriodicInterestBearingWorkingBalance class).
	loan01.earlyPayoffDate = [inputCreationHelper multiScenSimEndDateWithDefault:
			[DateHelper dateFromStr:@"2014-06-14"]];



	SimResultsController *simResults = [[[SimResultsController alloc] 
		initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:7314.84 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:4030.14 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];


	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:16346.43 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:12360.71 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:8133.47 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:8133.47 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:8133.47 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];

	
}


-(void)testLoanWithDownPayment
{

	[self resetCoredData];
	
		self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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
	
	// The cash balance starts at $1000.
	// The down payment is $360, immediating taking the cash balance down to $640.
	// $360 is then borrowed, taking the initial cash balance back up to $1000.
	// In the first year, 11 payments are made, taking the cash balance down to $890 
	// In subsequent years, 12 payments are made, taking the cash balance down $120 in each of those years.
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1250.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1130.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1010.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];


}


-(void)testLoanWithExtraPayments
{

	[self resetCoredData];
	
		self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1390.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1030.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];
	
	// Re-run the simulator, but with extra payments disabled
	
	loan01.extraPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	[simResults runSimulatorForResults];


	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:260.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:20.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];


	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1260.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1020.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];


}

-(void)testDeferredLoanWithExtraPayments
{

	[self resetCoredData];
	
		self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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


	// Defer the loan payments by one year, don't pay the interest during this year. The resulting
	// payment needs to be include the interest.
	loan01.deferredPaymentEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.deferredPaymentDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2013-02-01"]];
	loan01.deferredPaymentPayInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	loan01.deferredPaymentSubsizedInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:720.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// Payments don't start until the 2nd year, so the balance stays at 720 for 2012
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:390.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:30.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];
	
	// The extra payment should come out of cash funds
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	// The loan originates in the first year, so the amount taken for cash is added to the cash balance.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1720.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1390.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1030.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];
}


-(void)testFutureLoan
{
	[self resetCoredData];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests. 
	//
	// Loans in the future were originally causing assertion failures in the simulation code.
	// This test ensures support for loans in the future does not regress.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:600.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:60];	
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-02-15"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];



	SimResultsController *simResults = [[[SimResultsController alloc] 
		initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// At the end of 2012, the balance should be 0, since the loan hasn't originated yet.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	// Starting on March 15, 2013, there should be 1 payment of $10 each month.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:380.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:260.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:140.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];

	
}


-(void)testFutureLoan02
{
	[self resetCoredData];
	
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];

	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests. 
	//
	// Loans in the future were originally causing assertion failures in the simulation code.
	// This test ensures support for loans in the future does not regress.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:6000.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:60];	
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2015-02-15"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];

	SimResultsController *simResults = [[[SimResultsController alloc] 
		initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// At the end of 2012, the balance should be 0, since the loan hasn't originated yet.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	// In the first 2 years, the balance should be 0, because the loan hasn't originated yet.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// Only 10 payments in the first year
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:5195.47 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// 12 payments in the second
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:4137.61 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];

	// Net worth should stay at 1000 until the loan starts to get paid off. Starting in 2015, the net worth
	// should reduce by total interest paid throughout the year. The results below were cross-checked against
	// the spreadsheet amortization in MonthlyMortgageInterestCalculation.xlsx.
	NetWorthXYPlotDataGenerator *netWorthData = [[[NetWorthXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:529.71 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:57.78 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:netWorthData withSimResults:simResults andExpectedVals:expected andLabel:@"Net worth" withAdjustedVals:FALSE];

}

-(void)testFutureLoanWithDeferredPaymentAndNoPaymentOfInterestWhileInDeferrment
{
	[self resetCoredData];

	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 10% interest loan over 36 months, but the loan's payments
	// don't start until after 12 months..

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-01-01"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];
	
	
	// Defer the loan payments by one year, don't pay the interest during this year. The resulting
	// payment needs to be include the interest.
	loan01.deferredPaymentEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.deferredPaymentDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-01"]];
	loan01.deferredPaymentPayInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	loan01.deferredPaymentSubsizedInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// Interest is not paid in the first year, so the balance will increase by 10%
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// The loan originates in 2013, but doesn't start payment until 2014. So at the end
	// of 2013, the loan balance should be 1000.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1095.58 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:766.09 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:402.10 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];
}

-(void)testFutureLoanWithDeferredPaymentAndPaymentOfInterestAndUnSubsidizedInterest
{
	[self resetCoredData];

	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-01-01"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];
	
	
	// Defer the loan payments by one year, don't pay the interest during this year. The resulting
	// payment needs to be include the interest.
	loan01.deferredPaymentEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.deferredPaymentDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-01"]];
	loan01.deferredPaymentPayInterest = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.deferredPaymentSubsizedInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// Interest is paid in the first year, so the balance will not increase by 10%
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// At the end of 2013, there's a little bit of unpaid interest on the account. This is paid off
	// before calculating the regular payment at the beginning of 2014.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1000.00 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:699.26 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:367.02 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];
	
	
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// The loan is taken in the first year, increasing the cash balance from 1000 to 2000
	// However, in 2013, approximately 10% interest is payed, even though the loan
	// is in deferrment until 2014.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1908.33 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// Repayment starts in 2014, so the payments in 2014 include both principal and
	// interest.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1521.13 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1133.92 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// Payments are deferred until 2016. Since the interest is subsidized, the balance stays the same.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:746.71
	 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];
	
}

-(void)testPastLoanWithDeferredPaymentAndNoPaymentOfInterestWhileInDeferrment
{
	[self resetCoredData];

	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 10% interest loan over 36 months. The loan originates in the
	// past w.r.t. the simulation start date, but the deferred payment starts after loan origination.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2011-01-01"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];
	
	
	// Defer the loan payments until one year after simulation start.
	loan01.deferredPaymentEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.deferredPaymentDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2013-01-01"]];
	loan01.deferredPaymentPayInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	loan01.deferredPaymentSubsizedInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// Interest is not paid in the first year, so the balance will increase by 10% (actually 10.4% APY)
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1210.31 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:846.31
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:444.21 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];
}


-(void)testPastLoanWithDeferredPaymentAndNoPaymentOfInterestWhileInDeferrmentAndPayoffInPast
{
	[self resetCoredData];

	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 10% interest loan over 36 months. The loan originates in the
	// past w.r.t. the simulation start date, but the deferred payment starts after loan origination.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2008-01-01"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];
	
	
	// Defer the loan payments until one year after simulation start.
	loan01.deferredPaymentEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.deferredPaymentDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2009-01-01"]];
	loan01.deferredPaymentPayInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	loan01.deferredPaymentSubsizedInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// The deferred payments complete before the simulation starts, so the balance starts at zero (actually 10.4% APY)
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];
}

-(void)testPastLoanWithDeferredPaymentAndNoPaymentOfInterestWhileInDeferrmentStartPmtsInPastFinishAfterSimStart
{
	[self resetCoredData];

	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 10% interest loan over 36 months. The loan originates in the
	// past w.r.t. the simulation start date, but the deferred payment starts after loan origination.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2009-01-01"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];
	
	
	// Defer the loan payments until one year after simulation start.
	loan01.deferredPaymentEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.deferredPaymentDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2011-01-01"]];
	loan01.deferredPaymentPayInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	loan01.deferredPaymentSubsizedInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// Deferred payments start in the year prior to sim start. The results are expected to be
	// the same as testPastLoanWithDeferredPaymentAndNoPaymentOfInterestWhileInDeferrment, but shifted back
	// 1 year.q
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:444.21 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];
}

-(void)testPastLoanWithDeferredPaymentAndNoPaymentOfInterestWhileInDeferrmentStartPmtsInPastFinishAfterSimStartAndStartingBalance
{
	[self resetCoredData];

	LoanInputTypeSelctionInfo *loanCreator =
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 10% interest loan over 36 months. The loan originates in the
	// past w.r.t. the simulation start date, but the deferred payment starts after loan origination.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	loan01.startingBalance = [NSNumber numberWithDouble:1000.0];

	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2009-01-01"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];
	
	
	// Defer the loan payments until one year after simulation start.
	loan01.deferredPaymentEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.deferredPaymentDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2011-01-01"]];
	loan01.deferredPaymentPayInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	loan01.deferredPaymentSubsizedInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// Deferred payments start in the year prior to sim start. The results are expected to be
	// the same as testPastLoanWithDeferredPaymentAndNoPaymentOfInterestWhileInDeferrment, but shifted back
	// 1 year.q
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:613.99 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:187.56 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];
}



-(void)testLoanWithDeferredPaymentAndPaymentOfInterestAndSubsidizedInterest
{
	[self resetCoredData];

	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:2000.0];


	LoanInputTypeSelctionInfo *loanCreator = 
		[[[LoanInputTypeSelctionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
			andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// In this test, we create a 0% interest loan over 36 months. This tests that the values
	// given as input to the loan carry through properly to the end results. Testing of loans
	// with interest is done in separate unit tests.

	LoanInput *loan01 = (LoanInput*)[loanCreator createInput];
	loan01.loanCost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	loan01.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:36];
	loan01.loanCostGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	loan01.origDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-12-31"]];
	loan01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];
	
	
	// Defer the loan payments by one year, don't pay the interest during this year. The resulting
	// payment needs to be include the interest.
	loan01.deferredPaymentEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.deferredPaymentDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2016-01-01"]];
	loan01.deferredPaymentPayInterest = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	loan01.deferredPaymentSubsizedInterest = [inputCreationHelper multiScenBoolValWithDefault:TRUE];


	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	LoanBalXYPlotDataGenerator *loanData = [[[LoanBalXYPlotDataGenerator alloc] initWithLoan:loan01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// Interest is paid in the first year, so the balance will not increase by 10%
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1000.00 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1000.00 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.00 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:699.26 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:loanData withSimResults:simResults andExpectedVals:expected andLabel:@"loan01" withAdjustedVals:FALSE];

	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	// The loan is taken in the first year, increasing the cash balance from 2000 to 3000
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:3000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:3000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:3000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:3000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// Payments are deferred until 2016. Since the interest is subsidized, the balance stays the same.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:2612.79 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];


}



-(void)testAccount
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.name = @"expense01";
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.name = @"expense01";
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	AssetInputTypeSelectionInfo *assetCreator = 
		[[[AssetInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	AssetInput *asset01 = (AssetInput*)[assetCreator createInput];
	asset01.name = @"Asset01";
	asset01.cost = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	asset01.apprecRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	asset01.purchaseDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-01-15"]];	
	asset01.saleDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-15"]];
	
	
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.name = @"expense01";
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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


-(void)testAccountDividend
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:2000.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0]; // 10% dividend each year
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	// The following results assume the dividend is reinvested, then the reinvested dividend also becomes part of the
	// basis for calculatig the future dividends. The quarterly dividend is also assumed to be 1/4 of the yearly
	// dividend, so 2.5% in this case.
	AcctDividendXYPlotDataGenerator *acctDividendData =
		[[[AcctDividendXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:103.81 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:114.59 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:126.48 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:139.61 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:154.11 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctDividendData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];



}

-(void)testAccountDividendWithPartialReinvestment
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0]; // 10% dividend each year
	acct01.dividendReinvestPercent = [inputCreationHelper multiScenPercentWithDefault:50.0]; // reinvest 50%, with the rest going to cash
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	SimResultsController *simResults = [[[SimResultsController alloc]
		initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	// The following results assume the dividend is reinvested, then the reinvested dividend also becomes part of the
	// basis for calculatig the future dividends. The quarterly dividend is also assumed to be 1/4 of the yearly
	// dividend, so 2.5% in this case.
	AcctDividendXYPlotDataGenerator *acctDividendData =
		[[[AcctDividendXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:101.89 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:107.08 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:112.53 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:118.27 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:124.30 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctDividendData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];

	AcctBalanceXYPlotDataGenerator *acctData01 = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1050.95 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1104.49 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1160.75 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1219.89 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1282.03 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctData01 withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];

	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:50.95 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:104.49 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:160.75 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:219.89 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:282.03 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];


}


-(void)testAccountDividendWithNoReinvestment
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0]; // 10% dividend each year
	acct01.dividendReinvestPercent = [inputCreationHelper multiScenPercentWithDefault:0.0]; // reinvest 50%, with the rest going to cash
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	SimResultsController *simResults = [[[SimResultsController alloc]
		initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	// The following results assume the dividend is reinvested, then the reinvested dividend also becomes part of the
	// basis for calculatig the future dividends. The quarterly dividend is also assumed to be 1/4 of the yearly
	// dividend, so 2.5% in this case.
	AcctDividendXYPlotDataGenerator *acctDividendData =
		[[[AcctDividendXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctDividendData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];

	AcctBalanceXYPlotDataGenerator *acctData01 = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
		
	[self checkPlotData:acctData01 withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];

	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1400.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];

}


-(void)testAccountCapitalGain
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Set the cash balance to 0.0, so the expense will trigger a withdrawal from the account.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:10000.0];
	acct01.costBasis = [NSNumber numberWithDouble:10000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];


	// The withdrawal from the account needs to be setup as a transfer. Otherwise, the
	// taxes paid will trigger a second withdrawal from the account, further increasing
	// the capital gains paid! (A previous version of this test case used an expense, and
	// the capital gains went from 227 to 233 and the taxes also went up. Also, having
	// a transfer as opposed to an expense also increases test coverage, since the other
	// test cases use expenses.
	TransferInputTypeSelectionInfo *transferCreator = [[[TransferInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	TransferInput *acctTransfer = (TransferInput*)[transferCreator createInput];
	acctTransfer.amount = [inputCreationHelper multiScenAmountWithDefault:2500.0];
	acctTransfer.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-01-01"]];
	acctTransfer.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	acctTransfer.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acctTransfer.fromEndpoint = acct01.acctTransferEndpointAcct;
	acctTransfer.toEndpoint = self.testAppVals.cash.transferEndpointCash;

	
	TaxInputTypeSelectionInfo *taxCreator = 
	[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
	andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	AccountCapitalGainItemizedTaxAmt *itemizedCapitalGain = [self.coreData insertObject:ACCOUNT_CAPITAL_GAIN_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedCapitalGain.account = acct01;
	itemizedCapitalGain.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedCapitalGain];

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctCapitalGainsXYPlotDataGenerator *acctGainsData =
		[[[AcctCapitalGainsXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:227.86
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctGainsData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];
			
			
	// Capital gains tax should be 25%
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:56.97 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"flatTax" withAdjustedVals:FALSE];
		
}

-(void)testAccountCostBasis
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Set the cash balance to 0.0, so the expense will trigger a withdrawal from the account.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:10000.0];
	acct01.costBasis = [NSNumber numberWithDouble:5000.0]; // Cost basis is 50% of starting balance
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];


	TransferInputTypeSelectionInfo *transferCreator = [[[TransferInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	TransferInput *acctTransfer = (TransferInput*)[transferCreator createInput];
	acctTransfer.amount = [inputCreationHelper multiScenAmountWithDefault:2500.0];
	acctTransfer.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-12-31"]];
	acctTransfer.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	acctTransfer.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acctTransfer.fromEndpoint = acct01.acctTransferEndpointAcct;
	acctTransfer.toEndpoint = self.testAppVals.cash.transferEndpointCash;

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctCapitalGainsXYPlotDataGenerator *acctGainsData =
		[[[AcctCapitalGainsXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1363.64
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctGainsData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];


	AcctCapitalLossXYPlotDataGenerator *acctLossData =
		[[[AcctCapitalLossXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctLossData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];

			
}


-(void)testAccountCostBasisWithLoss
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Set the cash balance to 0.0, so the expense will trigger a withdrawal from the account.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:10000.0];
	acct01.costBasis = [NSNumber numberWithDouble:20000.0]; // Cost basis is 200% of starting balance
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];


	TransferInputTypeSelectionInfo *transferCreator = [[[TransferInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	TransferInput *acctTransfer = (TransferInput*)[transferCreator createInput];
	acctTransfer.amount = [inputCreationHelper multiScenAmountWithDefault:2500.0];
	acctTransfer.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-12-31"]];
	acctTransfer.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	acctTransfer.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acctTransfer.fromEndpoint = acct01.acctTransferEndpointAcct;
	acctTransfer.toEndpoint = self.testAppVals.cash.transferEndpointCash;

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctCapitalGainsXYPlotDataGenerator *acctGainsData =
		[[[AcctCapitalGainsXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctGainsData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];
	
	
	AcctCapitalLossXYPlotDataGenerator *acctLossData =
		[[[AcctCapitalLossXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:2045.45
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
 	[self checkPlotData:acctLossData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];
				
}



-(void)testAccountCapitalGainWithDividend
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Set the cash balance to 0.0, so the expense will trigger a withdrawal from the account.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:10000.0];
	acct01.costBasis = [NSNumber numberWithDouble:10000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:5.0]; // 5% dividend each year
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];


	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	// Use a 1 time expense to trigger a withdrawal from the account - A transfer would work just as well.
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:2500.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2013-01-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	// The following results assume the dividend is reinvested, then the reinvested dividend also becomes part of the
	// basis for calculatig the future dividends. The quarterly dividend is also assumed to be 1/4 of the yearly
	// dividend, so 2.5% in this case.
	//
	// Note that the capital gain is a little bit lower than testAccountCapitalGain (without dividend).
	// This is because the capital gains are averaged across the entire cost base. Since this
	// test case includes a larger cost base, the capital gain from the same size sale of 2500 is
	// a little bit smaller.
	AcctCapitalGainsXYPlotDataGenerator *acctGainsData =
		[[[AcctCapitalGainsXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:223.36
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctGainsData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];
}

-(void)testAccountCapitalGainWithLargeGain
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Set the cash balance to 0.0, so the expense will trigger a withdrawal from the account.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:10000.0];
	acct01.costBasis = [NSNumber numberWithDouble:10000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:100.0];


	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	// Use a 1 time expense to trigger a withdrawal from the account - A transfer would work just as well.
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:2500.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-12-31"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctCapitalGainsXYPlotDataGenerator *acctGainsData =
		[[[AcctCapitalGainsXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// The account realized a gain of 100% in the first year, so 1/2 of the $20K is now
	// capital gains, while the other half is the cost basis. So, for a withdrawal of 2500,
	// the proportion attributable to cost basis is 50% * 2500 = 1250.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1250.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctGainsData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];
}



-(void)testAccountCapitalLoss
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Set the cash balance to 0.0, so the expense will trigger a withdrawal from the account.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:10000.0];
	acct01.costBasis = [NSNumber numberWithDouble:10000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	// Account starts with 10,000 in cost basis and value, but loses 10% of the value each year.
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:-10.0];


	// Similar to the testCapitalGain test case, a transfer must be used instead of
	// an expense. This is because there needs to be an income input to provide a gross
	// income from which to deduct the capital loss. An expense input would cause the
	// money for the expense to be withdrawn from the cash balance rather than the account.
	TransferInputTypeSelectionInfo *transferCreator = [[[TransferInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	TransferInput *acctTransfer = (TransferInput*)[transferCreator createInput];
	acctTransfer.amount = [inputCreationHelper multiScenAmountWithDefault:2500.0];
	acctTransfer.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-12-31"]];
	acctTransfer.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	acctTransfer.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acctTransfer.fromEndpoint = acct01.acctTransferEndpointAcct;
	acctTransfer.toEndpoint = self.testAppVals.cash.transferEndpointCash;

	
	// The yearly income is 200, but the standard deduction is 100. This leaves a taxable income of
	// 100 which is taxed at 25%. This means there should be $25 taxes paid each year.	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	TaxInputTypeSelectionInfo *taxCreator = 
	[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
	andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];


	// Setup an income of $100 per year, but a capital loss as a deduction. The loss should reduce the
	// taxable $25 of this $100 slightly.
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	IncomeItemizedTaxAmt *itemizedIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedIncome.income = income01;
	itemizedIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedIncome];

	AccountCapitalLossItemizedTaxAmt *itemizedCapitalLoss = [self.coreData insertObject:ACCOUNT_CAPITAL_LOSS_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedCapitalLoss.account = acct01;
	itemizedCapitalLoss.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedDeductions addItemizedAmtsObject:itemizedCapitalLoss];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctCapitalLossXYPlotDataGenerator *acctLossData =
		[[[AcctCapitalLossXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:277.78
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
 	[self checkPlotData:acctLossData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];
			
			
	// Capital gains tax should be 25%
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:180.55 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:250.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:250.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"flatTax" withAdjustedVals:FALSE];
			
}

-(void)testAccountCapitalLossWithLargeLoss
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Set the cash balance to 0.0, so the expense will trigger a withdrawal from the account.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:10000.0];
	acct01.costBasis = [NSNumber numberWithDouble:10000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:-90.0];


	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	// Use a 1 time expense to trigger a withdrawal from the account - A transfer would work just as well.
	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:500];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-12-31"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctCapitalLossXYPlotDataGenerator *acctLossData =
		[[[AcctCapitalLossXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// The account realized a loss of 90% in the first year, bringing the balance down to $1000.
	// The withdrawal of $500 brings the balance down to $500. However, as a proportion of the
	// cost basis, this results in 1/2 of of the $9000 loss being realized as a capital loss.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:4500.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:0.0
		andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctLossData withSimResults:simResults andExpectedVals:expected
			andLabel:@"acct 01" withAdjustedVals:FALSE];
}



-(void)testAccountWithdraw
{
	[self resetCoredData];
	
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:500.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:500.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
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
	
	AcctWithdrawalXYPlotDataGenerator *acctWithdrawalData = [[[AcctWithdrawalXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:500.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctWithdrawalData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];
	
	AllAcctWithdrawalXYPlotDataGenerator *allAcctWithdrawalData = [[[AllAcctWithdrawalXYPlotDataGenerator alloc] init] autorelease];
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

-(void)testTaxAccountInterest
{
	[self resetCoredData];
	
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:500.0];
	
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:1.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	
	AccountInterestItemizedTaxAmt *itemizeAcctInterest = [self.coreData insertObject:ACCOUNT_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizeAcctInterest.account = acct01;	
	itemizeAcctInterest.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizeAcctInterest];

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];


	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:25.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:27.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:30.25 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:33.275 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// Note - There is an outstanding defect for the interest/return on leap years. The interest rate is calculated for
	// a daily return, so on leap years, this amounts to 366 days per year. The amount below should actuall be 36.60, but
	// it is a little high because of this 1 day extra of interest.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:36.70 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected
		andLabel:@"flatTax" withAdjustedVals:FALSE];
	

	AcctBalanceXYPlotDataGenerator *acctData01 = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1210.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1331.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1464.1 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1610.93 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctData01 withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];



}


-(void)testCashBalWithExpense
{
	[self resetCoredData];

	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:1000.0];


	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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


-(void)testDeficitStartingBal
{

	[self resetCoredData];

	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	self.testAppVals.deficitInterestRate = [inputCreationHelper fixedValueForValue:0.0];
	self.testAppVals.deficitStartingBal = [NSNumber numberWithDouble:15000];


	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:1000.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];


	DeficitBalXYPlotDataGenerator *deficitData= [[[DeficitBalXYPlotDataGenerator alloc] init] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:14000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:13000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:12000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:11000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:10000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];

	[self checkPlotData:deficitData withSimResults:simResults andExpectedVals:expected andLabel:@"deficit balances" withAdjustedVals:FALSE];

	
}



- (void)testFlatTax {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
    	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:150.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:50.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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


- (void)testItemizedDeductionTaxesPaid {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
    	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	
	TaxInput *deductableTax = (TaxInput*)[taxCreator createInput];
	TaxBracketEntry *deductableTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	deductableTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	deductableTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[deductableTax.taxBracket addTaxBracketEntriesObject:deductableTaxEntry];
	deductableTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:0.0];
	deductableTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	IncomeItemizedTaxAmt *itemizedDeductableTaxIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedDeductableTaxIncome.income = income01;
	itemizedDeductableTaxIncome.multiScenarioApplicablePercent = 
			[self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[deductableTax.itemizedIncomeSources addItemizedAmtsObject:itemizedDeductableTaxIncome];


	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	TaxBracketEntry *flatTaxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	flatTaxEntry.cutoffAmount = [NSNumber numberWithDouble:0.0];
	flatTaxEntry.taxPercent = [NSNumber numberWithDouble:25.0];
	[flatTax.taxBracket addTaxBracketEntriesObject:flatTaxEntry];
	flatTax.stdDeductionAmt = [self.inputCreationHelper multiScenAmountWithDefault:0.0];
	flatTax.stdDeductionGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	IncomeItemizedTaxAmt *itemizedFlatTaxIncome = [self.coreData insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedFlatTaxIncome.income = income01;
	itemizedFlatTaxIncome.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedIncomeSources addItemizedAmtsObject:itemizedFlatTaxIncome];
	
	TaxesPaidItemizedTaxAmt *itemizedTaxesPaid = [self.coreData insertObject:TAXES_PAID_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedTaxesPaid.tax = deductableTax;
	itemizedTaxesPaid.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	[flatTax.itemizedDeductions addItemizedAmtsObject:itemizedTaxesPaid];
	
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData 
		andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	// The flat tax rate is 25%. The deductable tax rate is also 25%, or %50. Since the deductable tax is listed as 
	// a deduction for the flat tax, it should cut the flat taxable income to $150. Then, 25% of $150 is $37.5.
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:37.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:37.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:37.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:37.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:37.5 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:50.0];
	expense01.cashFlowEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	flatTax.taxBracket.cutoffGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
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


- (void)testTaxBracketWithCutoffGrowth {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
	
	// In this test, the first $100 is taxed at 25%, but anything above that is taxed at 50%
    	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	flatTax.taxBracket.cutoffGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];
	
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
	
		
	// Since the income is not going up each year, the amount of taxes paid will actually go down
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:72.49 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:69.74 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:66.72 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:63.39 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:59.72 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:flatTaxData withSimResults:simResults andExpectedVals:expected andLabel:@"bracketed tax" withAdjustedVals:FALSE];
	
    
    NSLog(@"... Done testing sim engine");
    
     
}

- (void)testTaxBracketWithCutoffGrowthAndIncomeGrowth {
        
 	[self resetCoredData];
   
    NSLog(@"Starting sim engine test ...");
	
	// In this test, the first $100 is taxed at 25%, but anything above that is taxed at 50%
    	
	IncomeInputTypeSelectionInfo *incomeCreator = 
		[[[IncomeInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	TaxInput *flatTax = (TaxInput*)[taxCreator createInput];
	
	flatTax.taxBracket.cutoffGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:10.0];
	
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
	
		
	// Since the income is not going up each year, the amount of taxes paid will actually go down
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:72.85 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:80.17 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:88.19 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:97.01 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:106.70 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:10.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-01"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
		
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
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
	
	
	// Parameters:
	// expense01: Yearly expense of $100
	// acct01: account with starting balance of $1000
	// flatTax: 25% flat tax, with itemized & taxable withdrawal on acct01
	//
	// Expected Behavior:
	// There is a $100 withdrawal from acct01, and this amount is taxable. 
	// To cover taxes, there should be an additional amount $25 withdrawn; 
	// this will bring the total expected yearly withdrawal to $125. 
	// But then ... additional amounts must be withdrawn to pay the $25 taxes, 
	// resulting in an additional $6.25 taxes paid. And yet again, a withdrawal 
	// is taken to pay the $6.25, so an additional $1.56 is paid. The 
	// simulator (specifically in the TaxInputCalc class) has an 
	// iterative loop to calculate this tax.
	
	
	// In this test there is an expense of $100/year. This expense triggers a withdrawal
	// from acct01, which is itemized a tax source for a tax of 25%.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:0.0];
	
	
	// For testing purposes, default to 1 year (instead of 50). By setting the sim end date to 11
	// months, the simulator will round up to 1 year (instead of rounding up to 6 years).
	RelativeEndDate *theSimEndDate = [self.coreData createDataModelObject:RELATIVE_END_DATE_ENTITY_NAME];
	theSimEndDate.monthsOffset = [NSNumber numberWithInt:11];
	self.testAppVals.simEndDate = theSimEndDate;


	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];

	ExpenseInput *expense01 = (ExpenseInput*)[expenseCreator createInput];
	expense01.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	expense01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	expense01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	expense01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] 
		initWithInputCreationHelper:self.inputCreationHelper
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.withdrawalPriority = [inputCreationHelper multiScenFixedValWithDefault:1.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	TaxInputTypeSelectionInfo *taxCreator = 
		[[[TaxInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper 
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
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
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:133.30 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctWithdrawalData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01 withdrawals" withAdjustedVals:FALSE];
	
	TaxesPaidXYPlotDataGenerator *flatTaxData = [[[TaxesPaidXYPlotDataGenerator alloc] initWithTax:flatTax] autorelease];
	expected = [[[NSMutableArray alloc]init] autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:33.30 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	IncomeInput *income01 = (IncomeInput*)[incomeCreator createInput];
	income01.amount = [inputCreationHelper multiScenAmountWithDefault:200.0];
	income01.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	income01.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	income01.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
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
		andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
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



-(void)testAccountTransfer
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:2000.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:450.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	acct01.contribAmount = [inputCreationHelper multiScenAmountWithDefault:0.0];	
	acct01.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct01.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct01.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-20"]];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];


	SavingsAccount *acct02 = (SavingsAccount*)[acctCreator createInput];
	acct02.name = @"Acct02";
	acct02.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct02.contribAmount = [inputCreationHelper multiScenAmountWithDefault:0.0];	
	acct02.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	acct02.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct02.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct02.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2015-01-20"]];
	acct02.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	TransferInputTypeSelectionInfo *transferCreator = [[[TransferInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	TransferInput *acctTransfer = (TransferInput*)[transferCreator createInput];
	acctTransfer.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	acctTransfer.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	acctTransfer.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acctTransfer.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acctTransfer.fromEndpoint = acct01.acctTransferEndpointAcct;
	acctTransfer.toEndpoint = acct02.acctTransferEndpointAcct;
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	
	AcctWithdrawalXYPlotDataGenerator *acctWithdrawalData = [[[AcctWithdrawalXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:50.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[self checkPlotData:acctWithdrawalData withSimResults:simResults andExpectedVals:expected 
		andLabel:@"acct01" withAdjustedVals:FALSE];

	
	AcctContribXYPlotGenerator *acctContribData = [[[AcctContribXYPlotGenerator alloc] initWithAccount:acct02] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:50.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctContribData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];
	

}

-(void)testCashToAccountTransfer
{
	[self resetCoredData];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:450.0];
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.name = @"Acct01";
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	acct01.contribAmount = [inputCreationHelper multiScenAmountWithDefault:0.0];	
	acct01.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct01.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct01.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-20"]];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	TransferInputTypeSelectionInfo *transferCreator = [[[TransferInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	TransferInput *acctTransfer = (TransferInput*)[transferCreator createInput];
	acctTransfer.amount = [inputCreationHelper multiScenAmountWithDefault:100.0];
	acctTransfer.startDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-1-15"]];
	acctTransfer.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acctTransfer.amountGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	acctTransfer.fromEndpoint = self.testAppVals.cash.transferEndpointCash;
	acctTransfer.toEndpoint = acct01.acctTransferEndpointAcct;
	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	
	CashBalXYPlotDataGenerator *cashData = [[[CashBalXYPlotDataGenerator alloc] init] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:350.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:250.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:150.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:50.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:0.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:cashData withSimResults:simResults andExpectedVals:expected andLabel:@"cash balances" withAdjustedVals:FALSE];

	
	AcctContribXYPlotGenerator *acctContribData = [[[AcctContribXYPlotGenerator alloc] initWithAccount:acct01] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:50.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctContribData withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];
	
	
	AcctBalanceXYPlotDataGenerator *acctData01 = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	expected = [[[NSMutableArray alloc]init]autorelease];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	// Withdrawals don't occur from acct01 until 2014
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1300.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1400.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1450.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	
	[self checkPlotData:acctData01 withSimResults:simResults andExpectedVals:expected andLabel:@"acct01" withAdjustedVals:FALSE];

	

}

- (void)testStartDateInMiddleOfYear {
        
	// All the other tests have a start date of 2012/01/01. However, the user can pick any start date,
	// and having this start date in the middle of the year introduces interesting behavior w.r.t.
	// the first year of results calculation, starting account balances, etc.
	[self resetCoredData];
	self.testAppVals.simStartDate = [DateHelper dateFromStr:@"2012-05-15"];

	
	
    NSLog(@"Starting sim engine test ...");
    	
	// Account contributions will only occur if there is a balance of cash to draw from. So,
	// for testing purposes, we initialize the cash balance so that contributions will occur.
	self.testAppVals.cash.startingBalance = [NSNumber numberWithDouble:10000.0];
	
	SavingsAccountTypeSelectionInfo *acctCreator = [[[SavingsAccountTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelController:self.coreData andLabel:@"" andSubtitle:@"" andImageName:nil] autorelease];
	
	
	SavingsAccount *acct01 = (SavingsAccount*)[acctCreator createInput];
	acct01.startingBalance = [NSNumber numberWithDouble:1000.0];
	acct01.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];

	acct01.contribAmount = [inputCreationHelper multiScenAmountWithDefault:100.0];	
	acct01.contribStartDate = [inputCreationHelper multiScenSimDateWithDefault:[DateHelper dateFromStr:@"2012-01-15"]];
	acct01.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyYearly];
	acct01.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefault:[DateHelper dateFromStr:@"2014-01-20"]];
	acct01.interestRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	
	SimResultsController *simResults = [[[SimResultsController alloc] initWithDataModelController:self.coreData andSharedAppValues:self.testAppVals] autorelease];
	[simResults runSimulatorForResults];
	
	AcctBalanceXYPlotDataGenerator *acctData = [[[AcctBalanceXYPlotDataGenerator alloc] initWithAccount:acct01] autorelease];
	NSMutableArray *expected = [[[NSMutableArray alloc]init]autorelease];
	// The contribution isn't included in the first year, since it happens before the simulation start date.
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2012 andVal:1000.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2013 andVal:1100.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2014 andVal:1200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2015 andVal:1200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
	[expected addObject:[[[YearValPlotDataVal alloc] initWithYear:2016 andVal:1200.0 andSimStartValueAdjustmentMultiplier:1.0] autorelease]];
  
	
	[self checkPlotData:acctData withSimResults:simResults andExpectedVals:expected
		andLabel:@"acct01" withAdjustedVals:FALSE];
 
	   
    NSLog(@"... Done testing sim engine");
    
     
}



@end
