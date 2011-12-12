//
//  ExpenseXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExpenseXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"
#import "LocalizationHelper.h"
#import "ExpenseInput.h"

@implementation ExpenseXYPlotDataGenerator

@synthesize expense;

-(id)initWithExpense:(ExpenseInput*)theExpense
{
	self = [super init];
	if(self)
	{
		assert(theExpense != nil);
		self.expense  = theExpense;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}


-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double yearlyExpense = [eoyResult.expenses getResultForInput:self.expense];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:yearlyExpense];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return [NSString stringWithFormat: LOCALIZED_STR(@"RESULTS_EXPENSES_DATA_LABEL_FORMAT"),
		expense.name];
}

-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return [simResults.expensesSimulated containsObject:self.expense];
}

-(void)dealloc
{
	[super dealloc];
	[expense release];
}


@end
