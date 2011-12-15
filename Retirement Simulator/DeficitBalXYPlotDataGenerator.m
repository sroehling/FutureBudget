//
//  DeficitBalXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeficitBalXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "LocalizationHelper.h"

@implementation DeficitBalXYPlotDataGenerator


-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double deficitBal = eoyResult.deficitBal;
		
		[plotData addPlotDataPointForYear:resultYear andYVal:deficitBal];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return LOCALIZED_STR(@"RESULTS_DEFICIT_BALANCE_DATA_LABEL");
}

-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return TRUE;
}



@end
