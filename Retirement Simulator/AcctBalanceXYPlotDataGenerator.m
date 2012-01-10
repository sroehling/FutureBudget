//
//  AcctBalanceXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AcctBalanceXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"
#import "Account.h"
#import "LocalizationHelper.h"

@implementation AcctBalanceXYPlotDataGenerator



-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double acctBal = [eoyResult.acctBalances getResultForInput:self.account];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:acctBal
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return [NSString stringWithFormat: LOCALIZED_STR(@"RESULTS_ACCT_BALANCE_DATA_LABEL_FORMAT"),
		self.account.name];
}

-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return [simResults.acctsSimulated containsObject:self.account];
}

@end
