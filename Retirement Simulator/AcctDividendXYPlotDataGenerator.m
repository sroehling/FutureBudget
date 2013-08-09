//
//  AcctDividendXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/7/13.
//
//

#import "AcctDividendXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"
#import "Account.h"
#import "LocalizationHelper.h"


@implementation AcctDividendXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double acctDiv = [eoyResult.acctDividends getResultForInput:self.account];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:acctDiv
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return [NSString stringWithFormat: LOCALIZED_STR(@"RESULTS_ACCT_DIVIDEND_DATA_LABEL_FORMAT"),
		self.account.name];
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_YEARLY_TOTAL");
}



@end
