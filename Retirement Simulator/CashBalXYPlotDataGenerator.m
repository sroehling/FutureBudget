//
//  CashBalXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CashBalXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "LocalizationHelper.h"

@implementation CashBalXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double cashBal = eoyResult.cashBal;
		
		[plotData addPlotDataPointForYear:resultYear andYVal:cashBal
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return LOCALIZED_STR(@"RESULTS_CASH_BALANCE_DATA_LABEL");
}

-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return TRUE;
}



@end
