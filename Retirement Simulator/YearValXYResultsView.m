//
//  YearValXYResultsView.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YearValXYResultsView.h"
#import "ResultsViewInfo.h"
#import "CorePlot-CocoaTouch.h"
#import "CPTGraphHostingView.h"
#import "LocalizationHelper.h"
#import "YearValXYPlotData.h"
#import "SimResultsController.h"
#import "YearValPlotDataVal.h"
#import "SharedAppValues.h"

#define YEARXYVAL_CONTENT_MARGIN_TOP 24.0f
#define YEARXYVAL_RESULTS_TYPE_SELECTOR_HEIGHT 20.0f

@implementation YearValXYResultsView

@synthesize chartContentView;
@synthesize currentData;
@synthesize plotDataGenerator;
@synthesize resultsViewInfo;
@synthesize graphView;
@synthesize resultsTypeSelection;


-(id)initWithResultsViewInfo:(ResultsViewInfo *)theViewInfo 
	andPlotDataGenerator:(id<YearValXYPlotDataGenerator>)thePlotDataGenerator
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
	
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | 
					UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor darkGrayColor];

		self.chartContentView = [[[UIView alloc] init] autorelease];
		self.chartContentView.backgroundColor = [UIColor blackColor];
		self.chartContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | 
						UIViewAutoresizingFlexibleWidth;
		[self addSubview:self.chartContentView];
		
		
		NSArray*itemArray =[NSArray arrayWithObjects:@"Chart",@"Table", nil]; 
		self.resultsTypeSelection =[[UISegmentedControl alloc] initWithItems:itemArray]; 
		self.resultsTypeSelection.tintColor = [UIColor darkGrayColor];
		self.resultsTypeSelection.frame = CGRectMake(0,0,130,YEARXYVAL_RESULTS_TYPE_SELECTOR_HEIGHT); 
		self.resultsTypeSelection.segmentedControlStyle =UISegmentedControlStyleBar; 
		self.resultsTypeSelection.selectedSegmentIndex =0;
		 
		[self.resultsTypeSelection addTarget:self 
			action:@selector(resultsTypeSelectionChanged:) 
			forControlEvents: UIControlEventValueChanged];
		
		[self addSubview:self.resultsTypeSelection];

		assert(thePlotDataGenerator != nil);
		self.plotDataGenerator = thePlotDataGenerator;
		
		assert(theViewInfo != nil);
		self.resultsViewInfo = theViewInfo;
    }
    return self;
}

-(void)resultsTypeSelectionChanged:(id)sender
{
	if(self.resultsTypeSelection.selectedSegmentIndex == 0)
	{
		self.chartContentView.hidden = FALSE;
	}
	else {
		self.chartContentView.hidden = TRUE;
	}
}

-(void)generatePlot
{	

	if([self.plotDataGenerator resultsDefinedInSimResults:
			self.resultsViewInfo.simResultsController])
	{
	
		self.graphView = [[[CPTGraphHostingView alloc] 
			initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
	
		self.currentData = 
			[self.plotDataGenerator 
				generatePlotDataFromSimResults:self.resultsViewInfo.simResultsController];
		assert(self.currentData != nil);
		double resultMinVal = self.currentData.minYVal;
		double resultMaxVal = self.currentData.maxYVal;


		// Create graph from theme
		CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
		CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
		[graph applyTheme:theme];
		graphView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
		graphView.hostedGraph = graph;
		
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
		
		NSInteger resultMinYear = self.resultsViewInfo.simResultsController.resultMinYear;
		NSInteger resultMaxYear = self.resultsViewInfo.simResultsController.resultMaxYear;

		// Setup plot space
		CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
		plotSpace.allowsUserInteraction = NO;
		plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(resultMinYear) 
			length:CPTDecimalFromFloat(resultMaxYear-resultMinYear)];
			
			
		// Pad the range of the Y axis so the user
		// can always see the results.	
		double yLength = resultMaxVal - resultMinVal;
		double minYRange;
		double maxYRange;
		if(yLength > 10000)
		{
			minYRange = resultMinVal - 10000;
			maxYRange = resultMaxVal + 10000;
		}	
		else
		{
			minYRange = resultMinVal - 5000;
			maxYRange = resultMaxVal + 5000;			
		}
		plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minYRange) 
			length:CPTDecimalFromFloat(maxYRange-minYRange)];

		// Axes
		CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
		CPTXYAxis *x = axisSet.xAxis;
		x.title = LOCALIZED_STR(@"RESULTS_YEAR_X_AXIS_TITLE");
		x.majorIntervalLength = CPTDecimalFromString(@"5");
		x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(minYRange);
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
			[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(minYRange-excludeRange) 
				length:CPTDecimalFromFloat(excludeRange + 1 )], 
			[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(maxYRange+100000) 
				length:CPTDecimalFromFloat(excludeRange)], 
			nil];

		// Create a green plot area
		CPTScatterPlot *dataSourceLinePlot = [[[CPTScatterPlot alloc] init] autorelease];
		CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
		lineStyle.lineWidth = 2.0f;
		lineStyle.lineColor = [CPTColor greenColor];
		dataSourceLinePlot.dataLineStyle = lineStyle;
		dataSourceLinePlot.identifier = @"Green Plot";
		dataSourceLinePlot.dataSource = self;

		// Animate in the new plot, as an example
		dataSourceLinePlot.opacity = 0.0f;
		[graph addPlot:dataSourceLinePlot];
		
		CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		fadeInAnimation.duration = 1.0f;
		fadeInAnimation.removedOnCompletion = NO;
		fadeInAnimation.fillMode = kCAFillModeForwards;
		fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
		[dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];	
	
		graphView.alpha = 0.0;
		graphView.backgroundColor = [UIColor blackColor];
		
		[[self.chartContentView subviews]
			makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[self.chartContentView addSubview:graphView];
		[self setNeedsLayout];
		[UIView animateWithDuration:0.5 animations:^{graphView.alpha = 1.0;}];

		
	} // if results defined for the plot data
}

-(void)generateResults
{
	[self generatePlot];
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect chartFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	chartFrame.size.height = chartFrame.size.height - YEARXYVAL_CONTENT_MARGIN_TOP;
	chartFrame.origin.y = YEARXYVAL_CONTENT_MARGIN_TOP;

	[self.chartContentView setFrame:chartFrame];
	if(self.graphView != nil)
	{
		CGRect graphFrame = CGRectMake(0,0, chartFrame.size.width, chartFrame.size.height);
		[self.graphView setFrame:graphFrame];
	}
	
	CGRect resultsTypeFrame = self.resultsTypeSelection.frame;
	resultsTypeFrame.origin.x = self.frame.size.width/2.0 - resultsTypeFrame.size.width/2.0;
	resultsTypeFrame.origin.y = (YEARXYVAL_CONTENT_MARGIN_TOP - resultsTypeFrame.size.height)/2.0;
	[self.resultsTypeSelection setFrame:resultsTypeFrame];
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
		SharedAppValues *sharedAppVals = [SharedAppValues 
			getUsingDataModelController:self.resultsViewInfo.simResultsController.dataModelController];
			
		if([sharedAppVals.adjustResultsForSimStartDate boolValue])
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



-(void)dealloc
{
	[currentData release];
	[plotDataGenerator release];
	[chartContentView release];
	[resultsViewInfo release];
	[graphView release];
	[resultsTypeSelection release];
	[super dealloc];
}

@end
