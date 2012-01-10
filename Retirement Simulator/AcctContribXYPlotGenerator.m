//
//  AcctContribXYPlotGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AcctContribXYPlotGenerator.h"


#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"
#import "Account.h"
#import "LocalizationHelper.h"

@implementation AcctContribXYPlotGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double acctContrib = [eoyResult.acctContribs getResultForInput:self.account];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:acctContrib
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return [NSString stringWithFormat: LOCALIZED_STR(@"RESULTS_ACCT_CONTRIB_DATA_LABEL_FORMAT"),
		self.account.name];
}

-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return [simResults.acctsSimulated containsObject:self.account];
}

@end
