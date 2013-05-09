//
//  AcctCapitalLossXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/13.
//
//

#import "AcctCapitalLossXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"
#import "Account.h"
#import "LocalizationHelper.h"


@implementation AcctCapitalLossXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double capLoss = [eoyResult.acctCapitalLoss getResultForInput:self.account];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:capLoss
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return [NSString stringWithFormat: LOCALIZED_STR(@"RESULTS_ACCT_CAPITAL_LOSS_DATA_LABEL_FORMAT"),
		self.account.name];
}


@end
