//
//  AcctCapitalGainsXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/9/13.
//
//

#import "AcctCapitalGainsXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"
#import "Account.h"
#import "LocalizationHelper.h"


@implementation AcctCapitalGainsXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double capGains = [eoyResult.acctCapitalGains getResultForInput:self.account];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:capGains
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return [NSString stringWithFormat: LOCALIZED_STR(@"RESULTS_ACCT_CAPITAL_GAINS_DATA_LABEL_FORMAT"),
		self.account.name];
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_YEARLY_TOTAL");
}


@end
