//
//  AssetValueXYPlotDataGenerator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AssetValueXYPlotDataGenerator.h"

#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "EndOfYearDigestResult.h"
#import "EndOfYearInputResults.h"
#import "LocalizationHelper.h"
#import "AssetInput.h"

@implementation AssetValueXYPlotDataGenerator

@synthesize assetInput;

-(id)initWithAsset:(AssetInput*)theAsset
{
	self = [super init];
	if(self)
	{
		assert(theAsset != nil);
		self.assetInput = theAsset;
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
		double assetValue = [eoyResult.assetValues getResultForInput:self.assetInput];
		
		[plotData addPlotDataPointForYear:resultYear andYVal:assetValue
			andSimStartValueMultiplier:eoyResult.simStartDateValueMultiplier];
	}

	return plotData;
}

-(NSString*)dataLabel
{
	return [NSString stringWithFormat: LOCALIZED_STR(@"RESULTS_ASSET_DATA_LABEL_FORMAT"),
		assetInput.name];
}

-(NSString*)dataYearlyUnitLabel
{
    return LOCALIZED_STR(@"RESULTS_YEAR_UNIT_LABEL_END_OF_YEAR");
}


-(BOOL)resultsDefinedInSimResults:(SimResultsController*)simResults
{
	return [simResults.assetsSimulated containsObject:self.assetInput];
}


-(void)dealloc
{
	[assetInput release];
	[super dealloc];
}


@end
