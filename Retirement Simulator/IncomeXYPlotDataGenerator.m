//
//  IncomeXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IncomeXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResults.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"
#import "LocalizationHelper.h"
#import "IncomeInput.h"

@implementation IncomeXYPlotDataGenerator

@synthesize income;

-(id)initWithIncome:(IncomeInput*)theIncome
{
	self = [super init];
	if(self)
	{
		assert(theIncome != nil);
		self.income  = theIncome;
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
		double yearlyIncome = [eoyResult.incomes getResultForInput:self.income];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:yearlyIncome
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return [NSString stringWithFormat: LOCALIZED_STR(@"RESULTS_INCOME_DATA_LABEL_FORMAT"),
		income.name];
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_YEARLY_TOTAL");
}


-(BOOL)resultsDefinedInSimResults:(SimResults*)simResults
{
	return [simResults.incomesSimulated containsObject:self.income];
}

-(void)dealloc
{
	[income release];
	[super dealloc];
}

@end
