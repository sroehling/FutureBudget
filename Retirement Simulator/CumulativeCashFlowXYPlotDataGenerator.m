//
//  CumulativeCashFlowXYPlotDataGenerator.m
//  FutureBudget
//
//  Created by Steve Roehling on 7/11/13.
//
//

#import "CumulativeCashFlowXYPlotDataGenerator.h"
#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "LocalizationHelper.h"
#import "EndOfYearDigestResult.h"

@implementation CumulativeCashFlowXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	double cumYearEndCashFlow = 0.0;
	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double yearEndCashFlow = [eoyResult cashFlow];
		
		cumYearEndCashFlow += yearEndCashFlow;
		
		[plotData addPlotDataPointForYear:resultYear andYVal:cumYearEndCashFlow
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
	return LOCALIZED_STR(@"RESULTS_CUMULATIVE_CASH_FLOW_DATA_LABEL");
}


@end
