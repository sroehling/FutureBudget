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


@end
