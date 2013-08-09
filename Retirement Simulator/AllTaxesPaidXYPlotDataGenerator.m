//
//  AllTaxesPaidXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AllTaxesPaidXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "LocalizationHelper.h"

@implementation AllTaxesPaidXYPlotDataGenerator

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double taxesPaid = eoyResult.sumTaxesPaid;
		
		[plotData addPlotDataPointForYear:resultYear andYVal:taxesPaid
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return LOCALIZED_STR(@"RESULTS_TAXES_ALL_TAXES_PAID_DATA_LABEL");
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_YEARLY_TOTAL");
}



-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return TRUE;
}

@end
