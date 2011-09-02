//
//  ResultsViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewController.h"
#import "DataModelController.h"
#import "SimEngine.h"
#import "FiscalYearDigest.h"
#import "EndOfYearDigestResult.h"
#import "NumberHelper.h"
#import "LocalizationHelper.h"

#import "CorePlot-CocoaTouch.h"
#import "CPTGraphHostingView.h"

@implementation ResultsViewController

@synthesize dataForPlot;

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
	
	
	self.title = @"Results";
}

- (void)dealloc
{
    [super dealloc];
	[dataForPlot release];
}

#pragma mark - Simulator interface

- (void) runSimulatorForResults
{
     
    NSLog(@"Starting simulation run...");
    
    SimEngine *simEngine = [[SimEngine alloc] init ];
           
    [simEngine runSim];
	
	NSMutableArray *contentArray = [[[NSMutableArray alloc] init] autorelease];
	NSInteger minYear = NSIntegerMax;
	NSInteger maxYear = 0;
	double minVal = 100000000000.0;
	double maxVal = -100000000000.0;
	for(EndOfYearDigestResult *eoyResult in simEngine.digest.savedEndOfYearResults)
	{
		NSInteger resultYear = [eoyResult yearNumber];
		minYear = MIN(minYear, resultYear);
		maxYear = MAX(maxYear, resultYear);
		
		double yearEndNestEggSize = [eoyResult totalEndOfYearBalance];
		minVal = MIN(minVal,yearEndNestEggSize);
		maxVal = MAX(maxVal,yearEndNestEggSize);
		NSNumber *x = [NSNumber numberWithInteger:resultYear];
		NSNumber *y = [NSNumber numberWithDouble:yearEndNestEggSize];
		[contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
	}
	self.dataForPlot = contentArray;
	resultMaxYear = maxYear;
	resultMinYear = minYear;
	resultMinVal = minVal;
	resultMaxVal = maxVal;
    
    NSLog(@"... Done running simulation");
    
    [simEngine release];

}

#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];

    // This is called before the results view is presented. We use this as
    // an opportunity to update the results. 
    //
    // This should suffice for an initial/prototypical implementation.
    // However, if the number of inputs to process becomes large, then
    // we will likely need to process the inputs and run the simulator engine
    // in the background instead.
	NSLog(@"ResultsViewController: viewWillAppear");
    [self runSimulatorForResults];
	
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
	x.title = LOCALIZED_STR(@"RESULTS_NET_WORTH_PLOT_X_AXIS_TITLE");
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
	y.title = LOCALIZED_STR(@"RESULTS_NET_WORTH_PLOT_Y_AXIS_TITLE");
	y.titleOffset = 50;
    y.majorIntervalLength = CPTDecimalFromString(@"10000");
    y.minorTicksPerInterval = 5;
	NSNumberFormatter *netWorthFormatter = [[[NSNumberFormatter alloc]init] autorelease];
	[netWorthFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	netWorthFormatter.positiveSuffix = @"K";
	netWorthFormatter.negativeSuffix = @"K)";
	netWorthFormatter.multiplier = [NSNumber numberWithFloat:.001];
	[netWorthFormatter setMinimumFractionDigits:0];
	y.labelFormatter = netWorthFormatter;
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
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
    NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y")];
    return num;
}



@end
