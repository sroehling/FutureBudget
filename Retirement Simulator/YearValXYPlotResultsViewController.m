//
//  YearValXYPlotResultsViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YearValXYPlotResultsViewController.h"
#import "DataModelController.h"
#import "SimEngine.h"
#import "FiscalYearDigest.h"
#import "EndOfYearDigestResult.h"
#import "NumberHelper.h"
#import "LocalizationHelper.h"

#import "CorePlot-CocoaTouch.h"
#import "CPTGraphHostingView.h"
#import "LocalizationHelper.h"

#import "SimResultsController.h"
#import "StringValidation.h"
#import "ResultsViewInfo.h"
#import "YearValXYPlotData.h"
#import "YearValXYPlotDataGenerator.h"
#import "SharedAppValues.h"
#import "YearValPlotDataVal.h"


@implementation YearValXYPlotResultsViewController

@synthesize currentData;
@synthesize plotDataGenerator;

-(id)initWithResultsViewInfo:(ResultsViewInfo *)theViewInfo 
	andPlotDataGenerator:(id<YearValXYPlotDataGenerator>)thePlotDataGenerator
{
	self = [super initWithResultsViewInfo:theViewInfo];
	if(self) 
	{
		assert(thePlotDataGenerator != nil);
		self.plotDataGenerator = thePlotDataGenerator;
	}
	return self;
}

-(id)initWithResultsViewInfo:(ResultsViewInfo *)theViewInfo
{
	assert(0);
	return nil;
}

- (void)loadView
{
//	[super loadView];

	CPTGraphHostingView *graphView = [[CPTGraphHostingView alloc] 
		initWithFrame:[UIScreen mainScreen].applicationFrame];		
	self.view = graphView;
	[graphView release];


}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)dealloc
{
    [super dealloc];
	[currentData release];
	[plotDataGenerator release];
}

#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];

	NSLog(@"ResultsViewController: viewWillAppear");
	[self.viewInfo.simResultsController runSimulatorIfResultsOutOfDate];	

	
	if([self.plotDataGenerator resultsDefinedInSimResults:
			self.viewInfo.simResultsController])
	{
		self.currentData = 
			[self.plotDataGenerator generatePlotDataFromSimResults:self.viewInfo.simResultsController];
		assert(self.currentData != nil);
		double resultMinVal = self.currentData.minYVal;
		double resultMaxVal = self.currentData.maxYVal;

		
		
		// Create graph from theme
		graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
		CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
		[graph applyTheme:theme];
		CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
		hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
		hostingView.hostedGraph = graph;
		
		// Pad the plot as a whole
		graph.paddingLeft = 5.0;
		graph.paddingTop = 5.0;
		graph.paddingRight = 5.0;
		graph.paddingBottom = 5.0;
		
		
		// Pad around the plot area freme to give room for the x and y axis and labels.
		graph.plotAreaFrame.paddingTop = 10.0;
		graph.plotAreaFrame.paddingBottom = 60.0;
		graph.plotAreaFrame.paddingLeft = 80.0;
		graph.plotAreaFrame.paddingRight = 20.0;
		graph.plotAreaFrame.cornerRadius = 5.0;
		
		NSInteger resultMinYear = self.viewInfo.simResultsController.resultMinYear;
		NSInteger resultMaxYear = self.viewInfo.simResultsController.resultMaxYear;

		// Setup plot space
		CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
		plotSpace.allowsUserInteraction = NO;
		plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(resultMinYear) 
			length:CPTDecimalFromFloat(resultMaxYear-resultMinYear)];
		plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(resultMinVal) 
			length:CPTDecimalFromFloat(resultMaxVal-resultMinVal)];

		// Axes
		CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
		CPTXYAxis *x = axisSet.xAxis;
		x.title = LOCALIZED_STR(@"RESULTS_YEAR_X_AXIS_TITLE");
		x.majorIntervalLength = CPTDecimalFromString(@"5");
		x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(resultMinVal);
		x.minorTicksPerInterval = 5;
		NSNumberFormatter *yearFormatter = [[[NSNumberFormatter alloc]init] autorelease];
		[yearFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[yearFormatter setMinimumFractionDigits:0];
		[yearFormatter setGroupingSeparator:@""]; // don't show "," separatar for thousands
		x.labelFormatter = yearFormatter;
		x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
		x.labelExclusionRanges = [NSArray arrayWithObjects:
			[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) 
				length:CPTDecimalFromInt(resultMinYear+1)], 
			[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(resultMaxYear+1) 
				length:CPTDecimalFromInt(1000)], 
			nil];;

	   
		CPTXYAxis *y = axisSet.yAxis;
		y.title = [self.plotDataGenerator dataLabel];
		y.titleOffset = 50;
		y.minorTicksPerInterval = 5;
		
		
		// Depending on the maximum value in the results, scale the y axis  to either show values
		// denominated in millions or thousands. 
		NSNumberFormatter *yAxisFormatter = [[[NSNumberFormatter alloc]init] autorelease];
		[yAxisFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		if(resultMaxVal >= 1000000)
		{
			y.majorIntervalLength = CPTDecimalFromString(@"250000");
			yAxisFormatter.positiveSuffix = @"M";
			yAxisFormatter.negativeSuffix = @"M)";
			yAxisFormatter.multiplier = [NSNumber numberWithFloat:.000001];
			[yAxisFormatter setMinimumFractionDigits:0];
		}
		else
		{
			y.majorIntervalLength = CPTDecimalFromString(@"10000");
			yAxisFormatter.positiveSuffix = @"K";
			yAxisFormatter.negativeSuffix = @"K)";
			yAxisFormatter.multiplier = [NSNumber numberWithFloat:.001];
			[yAxisFormatter setMinimumFractionDigits:0];
		}
		y.labelFormatter = yAxisFormatter;
		y.orthogonalCoordinateDecimal = CPTDecimalFromInt(resultMinYear);
		y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
		
		double excludeRange = 1000000000.0;
		y.labelExclusionRanges = [NSArray arrayWithObjects:
			[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(resultMinVal-excludeRange) 
				length:CPTDecimalFromFloat(excludeRange + 1 )], 
			[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(resultMaxVal+100000) 
				length:CPTDecimalFromFloat(excludeRange)], 
			nil];

		// Create a green plot area
		CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
		CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
		lineStyle.lineWidth = 1.f;
		lineStyle.lineColor = [CPTColor greenColor];
		dataSourceLinePlot.dataLineStyle = lineStyle;
		dataSourceLinePlot.identifier = @"Green Plot";
		dataSourceLinePlot.dataSource = self;

	   // Put an area gradient under the plot above
		CPTColor *areaColor = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
		CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
		areaGradient.angle = -90.0f;
		CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient];
		dataSourceLinePlot.areaFill = areaGradientFill;
		dataSourceLinePlot.areaBaseValue = CPTDecimalFromString(@"1.75");

		// Animate in the new plot, as an example
		dataSourceLinePlot.opacity = 0.0f;
		[graph addPlot:dataSourceLinePlot];
		
		CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		fadeInAnimation.duration = 1.0f;
		fadeInAnimation.removedOnCompletion = NO;
		fadeInAnimation.fillMode = kCAFillModeForwards;
		fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
		[dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];	
	} // if results defined for the plot data
	else
	{
		// If there's no results defined for the data, then
		// we pop the view controller back to the main results
		// list. This can happen if the user disables or deletes
		// inputs which generate the plot data while the current
		// results view is showing that plot data.
		[self.navigationController popViewControllerAnimated:FALSE];
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [currentData.plotData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
	YearValPlotDataVal *plotDataVal = [currentData.plotData objectAtIndex:index];
	assert(plotDataVal !=nil);
	NSNumber *plotResult;
	if(fieldEnum == CPTScatterPlotFieldX)
	{
		plotResult = plotDataVal.year;
	}
	else
	{
		if([[SharedAppValues singleton].adjustResultsForSimStartDate boolValue])
		{
			plotResult = plotDataVal.inflationAdjustedVal;
		}
		else
		{
			plotResult = plotDataVal.unadjustedVal;
		}
	}
	assert(plotResult != nil);
//	NSLog(@"Plot result: %0.2f",[plotResult doubleValue]);
	return plotResult;
}


@end
