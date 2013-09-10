//
//  DeficitBalXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeficitBalXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResults.h"
#import "EndOfYearDigestResult.h"
#import "LocalizationHelper.h"

@implementation DeficitBalXYPlotDataGenerator


-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResults*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double deficitBal = eoyResult.deficitBal;
		
		[plotData addPlotDataPointForYear:resultYear andYVal:deficitBal
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return LOCALIZED_STR(@"RESULTS_DEFICIT_BALANCE_DATA_LABEL");
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_END_OF_YEAR");
}


-(BOOL)resultsDefinedInSimResults:(SimResults*)simResults
{
	return TRUE;
}



@end
