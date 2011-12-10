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
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"

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


-(YearValXYPlotData*)generatePlotDataFromSimResults:(SimResultsController*)simResults
{
	YearValXYPlotData *plotData = [[[YearValXYPlotData alloc] init] autorelease];

	for(EndOfYearDigestResult *eoyResult in simResults.endOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		double yearlyIncome = [eoyResult.incomes getResultForInput:self.income];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:yearlyIncome];
	}

	return plotData;
}


-(void)dealloc
{
	[super dealloc];
	[income release];
}

@end
