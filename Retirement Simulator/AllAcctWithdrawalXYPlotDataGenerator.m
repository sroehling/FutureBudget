//
//  AllAcctWithdrawalXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AllAcctWithdrawalXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "LocalizationHelper.h"

@implementation AllAcctWithdrawalXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double acctWithdrawals = eoyResult.sumAcctWithdrawal;
		
		[plotData addPlotDataPointForYear:resultYear andYVal:acctWithdrawals
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_WITHDRAW_DATA_LABEL");
}

-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return TRUE;
}


@end
