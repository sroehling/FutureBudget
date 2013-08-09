//
//  AllIncomeXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AllIncomeXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "LocalizationHelper.h"

@implementation AllIncomeXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double incomes = eoyResult.sumIncomes;
		
		[plotData addPlotDataPointForYear:resultYear andYVal:incomes
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return TRUE;
}

-(NSString*)dataLabel
{
	return LOCALIZED_STR(@"RESULTS_INCOME_ALL_DATA_LABEL");
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_YEARLY_TOTAL");
}




@end
