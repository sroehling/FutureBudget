//
//  LoanBalXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanBalXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"
#import "LoanInput.h"
#import "LocalizationHelper.h"

@implementation LoanBalXYPlotDataGenerator

@synthesize loan;

-(id)initWithLoan:(LoanInput*)theLoan
{
	self = [super init];
	if(self)
	{
		assert(theLoan != nil);
		self.loan = theLoan;
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
		double loanBal = [eoyResult.loanBalances getResultForInput:self.loan];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:loanBal];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return [NSString stringWithFormat: LOCALIZED_STR(@"RESULTS_LOAN_BALANCE_DATA_LABEL_FORMAT"),
		loan.name];
}

-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return [simResults.loansSimulated containsObject:self.loan];
}



-(void)dealloc
{
	[super dealloc];
	[loan release];
}

@end
