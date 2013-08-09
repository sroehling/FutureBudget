//
//  AllAcctBalanceXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AllAcctBalanceXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "LocalizationHelper.h"

@implementation AllAcctBalanceXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double acctBals = eoyResult.sumAcctBal;
		
		[plotData addPlotDataPointForYear:resultYear andYVal:acctBals
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_BALANCE_DATA_LABEL");
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_END_OF_YEAR");
}


-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return TRUE;
}




@end
