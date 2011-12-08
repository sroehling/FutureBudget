//
//  YearValXYPlotResultsViewFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YearValXYPlotResultsViewFactory.h"
#import "YearValXYPlotDataGenerator.h"
#import "YearValXYPlotResultsViewController.h"


@implementation YearValXYPlotResultsViewFactory

@synthesize plotDataGenerator;


-(id)initWithResultsViewInfo:(ResultsViewInfo *)theResultsViewInfo 
	andPlotDataGenerator:(id<YearValXYPlotDataGenerator>)theDataGenerator
{
	self = [super initWithResultsViewInfo:theResultsViewInfo];
	if(self)
	{
		assert(theDataGenerator != nil);
		self.plotDataGenerator = theDataGenerator;
	}
	return self;
}

-(id)initWithResultsViewInfo:(ResultsViewInfo *)theResultsViewInfo
{
	assert(0);
	return nil;
}


- (UIViewController*)createTableView
{
	return [[[YearValXYPlotResultsViewController alloc] 
		initWithResultsViewInfo:self.resultsViewInfo andPlotDataGenerator:self.plotDataGenerator] autorelease];
}

-(void)dealloc
{
	[super dealloc];
	[plotDataGenerator release];
}


	

@end
