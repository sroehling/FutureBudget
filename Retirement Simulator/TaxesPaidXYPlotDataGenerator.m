//
//  TaxesPaidXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TaxesPaidXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResults.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"
#import "LocalizationHelper.h"

#import "TaxInput.h"

@implementation TaxesPaidXYPlotDataGenerator

@synthesize taxInput;

-(id)initWithTax:(TaxInput*)theTax
{
	self = [super init];
	if(self)
	{
		assert(theTax != nil);
		self.taxInput = theTax;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResults*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double taxesPaid = [eoyResult.taxesPaid getResultForInput:self.taxInput];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:taxesPaid
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return [NSString stringWithFormat: LOCALIZED_STR(@"RESULTS_TAXES_PAID_DATA_LABEL_FORMAT"),
		taxInput.name];
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_YEARLY_TOTAL");
}


-(BOOL)resultsDefinedInSimResults:(SimResults*)simResults
{
	return [simResults.taxesSimulated containsObject:self.taxInput];
}



-(void)dealloc
{
	[taxInput release];
	[super dealloc];
}

@end
