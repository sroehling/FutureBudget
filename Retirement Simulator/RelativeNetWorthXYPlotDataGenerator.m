//
//  RelativeNetWorthXYPlotDataGenerator.m
//  FutureBudget
//
//  Created by Steve Roehling on 7/12/13.
//
//

#import "RelativeNetWorthXYPlotDataGenerator.h"
#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "LocalizationHelper.h"
#import "EndOfYearDigestResult.h"



@implementation RelativeNetWorthXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	BOOL firstYear = TRUE;
	double prevNetWorth = 0.0;

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double currYearNetWorth = [eoyResult totalEndOfYearBalance];
			
		if(!firstYear)
		{
			double relativeNetWorth = currYearNetWorth - prevNetWorth;
			[plotData addPlotDataPointForYear:resultYear andYVal:relativeNetWorth
				andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
		}
		prevNetWorth = currYearNetWorth;
		firstYear = FALSE;
	}

	return plotData;
}

-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return TRUE;
}

-(NSString*)dataLabel
{
	return LOCALIZED_STR(@"RESULTS_RELATIVE_NET_WORTH_DATA_LABEL");
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_YEARLY_TOTAL");
}


@end
