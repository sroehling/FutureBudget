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
		
		[plotData addPlotDataPointForYear:resultYear andYVal:assetValue];
	}

	return plotData;
}

-(void)dealloc
{
	[super dealloc];
	[assetInput release];
}


@end
