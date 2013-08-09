//
//  CashFlowXYPlotDataGenerator.m
//  FutureBudget
//
//  Created by Steve Roehling on 7/10/13.
//
//

#import "CashFlowXYPlotDataGenerator.h"
#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "LocalizationHelper.h"
#import "EndOfYearDigestResult.h"


@implementation CashFlowXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double yearEndCashFlow = [eoyResult cashFlow];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:yearEndCashFlow
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
	return LOCALIZED_STR(@"RESULTS_CASH_FLOW_DATA_LABEL");
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_YEARLY_TOTAL");
}


@end
