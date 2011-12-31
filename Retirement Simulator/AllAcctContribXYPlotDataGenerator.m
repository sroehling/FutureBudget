//
//  AllAcctContribXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AllAcctContribXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "LocalizationHelper.h"

@implementation AllAcctContribXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double acctContribs = eoyResult.sumAcctContrib;
		
		[plotData addPlotDataPointForYear:resultYear andYVal:acctContribs];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_CONTRIB_DATA_LABEL");
}

-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return TRUE;
}



@end
