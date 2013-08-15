//
//  TotalDebtXYPlotDataGenerator.m
//  FutureBudget
//
//  Created by Steve Roehling on 8/15/13.
//
//

#import "TotalDebtXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "LocalizationHelper.h"

@implementation TotalDebtXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];
    
	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double loanBals = eoyResult.sumLoanBal;
        double deficitBal = eoyResult.deficitBal;

        double totalDebt = loanBals + deficitBal;
        
		[plotData addPlotDataPointForYear:resultYear andYVal:totalDebt
               andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}
    
	return plotData;
}

-(NSString*)dataLabel
{
	return LOCALIZED_STR(@"RESULTS_SUMMARY_TOTAL_DEBT_DATA_LABEL");
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
