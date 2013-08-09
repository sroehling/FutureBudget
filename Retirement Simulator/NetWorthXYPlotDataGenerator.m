//
//  NetWorthXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NetWorthXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "LocalizationHelper.h"
#import "EndOfYearDigestResult.h"

@implementation NetWorthXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double yearEndNestEggSize = [eoyResult totalEndOfYearBalance];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:yearEndNestEggSize
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
	return LOCALIZED_STR(@"RESULTS_NET_WORTH_DATA_LABEL");
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_END_OF_YEAR");
}

@end
