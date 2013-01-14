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
#import "YearValXYResultsCell.h"
#import "NumberHelper.h"
#import "TableCellHelper.h"

#define YEARXYVAL_CONTENT_MARGIN_TOP 26.0f
#define YEARXYVAL_RESULTS_TYPE_SELECTOR_HEIGHT 24.0f

@implementation YearValXYResultsView

@synthesize chartContentView;
@synthesize currentData;
@synthesize plotDataGenerator;
@synthesize resultsViewInfo;
@synthesize graphView;
@synthesize resultsTypeSelection;
@synthesize tabularDataView;
@synthesize yearColLabel;
@synthesize valColLabel;
@synthesize headerView;


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
		
		self.tabularDataView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain] autorelease];
		self.tabularDataView.hidden = TRUE;
		self.tabularDataView.delegate = self;
		self.tabularDataView.dataSource = self;
		[self addSubview:self.tabularDataView];
		
		
		NSArray*itemArray =[NSArray arrayWithObjects:
			[UIImage imageNamed:@"bar-graph-icon"],
			[UIImage imageNamed:@"results-table-icon"], 
			nil]; 
		self.resultsTypeSelection =[[UISegmentedControl alloc] initWithItems:itemArray]; 
		self.resultsTypeSelection.tintColor = [UIColor darkGrayColor];
		self.resultsTypeSelection.frame = CGRectMake(0,0,100,YEARXYVAL_RESULTS_TYPE_SELECTOR_HEIGHT); 
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
		
		
		self.valColLabel = [TableCellHelper createWrappedLabel];
		self.yearColLabel = [TableCellHelper createLabel];
		self.headerView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		[self.headerView addSubview:self.yearColLabel];
		[self.headerView addSubview:self.valColLabel];
		self.headerView.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void)resultsTypeSelectionChanged:(id)sender
{
	if(self.resultsTypeSelection.selectedSegmentIndex == 0)
	{
		self.chartContentView.hidden = FALSE;
		self.tabularDataView.hidden = TRUE;
	}
	else {
		self.chartContentView.hidden = TRUE;
		self.tabularDataView.hidden = FALSE;
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
		
		
		SharedAppValues *sharedAppVals = [SharedAppValues 
			getUsingDataModelController:self.resultsViewInfo.simResultsController.dataModelController];
			
		BOOL adjustResultsToSimStartDate = [sharedAppVals.adjustResultsForSimStartDate boolValue];

		double resultMinVal = [self.currentData minYVal:adjustResultsToSimStartDate];
		double resultMaxVal = [self.currentData maxYVal:adjustResultsToSimStartDate];


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
		plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(resultMinYear-1) 
			length:CPTDecimalFromFloat(resultMaxYear-resultMinYear+2)];
			
			
		// Pad the range of the Y axis so the user
		// can always see the results.	
		double yLength = resultMaxVal - resultMinVal;
		double maxYRange;
		if(yLength > 10000)
		{
			maxYRange = resultMaxVal + 10000;
		}	
		else
		{
			maxYRange = resultMaxVal + 5000;			
		}
		double minYRange;
		if(resultMinVal > 0.0)
		{
			minYRange = 0.0;
		}
		else {
			minYRange = resultMinVal;
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
		y.orthogonalCoordinateDecimal = CPTDecimalFromInt(resultMinYear-1);
		y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
		
		double excludeRange = 1000000000.0;
		y.labelExclusionRanges = [NSArray arrayWithObjects:
			[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(minYRange-excludeRange) 
				length:CPTDecimalFromFloat(excludeRange + 1 )], 
			[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(maxYRange+100000) 
				length:CPTDecimalFromFloat(excludeRange)], 
			nil];
		
		// Create a bar line style
		CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
		barLineStyle.lineWidth = 1.0;
		barLineStyle.lineColor = [CPTColor grayColor];
			
		// Create first bar plot 
		CPTBarPlot *barPlot = [[[CPTBarPlot alloc] init] autorelease];
		barPlot.lineStyle = barLineStyle;
		barPlot.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
		barPlot.barBasesVary = NO;
		barPlot.baseValue = CPTDecimalFromDouble(0.0);
		barPlot.barWidth = CPTDecimalFromFloat(0.75f); // bar is 50% of the available space
		barPlot.barCornerRadius = 1.0f;
		barPlot.barsAreHorizontal = NO;
		barPlot.opacity = 0.0f;
		barPlot.barLabelTextStyle = nil;
	 
		barPlot.delegate = self;
		barPlot.dataSource = self;
		barPlot.identifier = @"Bar Plot 1";

		[graph addPlot:barPlot toPlotSpace:plotSpace];

		CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
		fadeInAnimation.duration = 1.0f;
		fadeInAnimation.removedOnCompletion = NO;
		fadeInAnimation.fillMode = kCAFillModeForwards;
		fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
		[barPlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];	


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
	[self.tabularDataView reloadData];
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect chartFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	chartFrame.size.height = chartFrame.size.height - YEARXYVAL_CONTENT_MARGIN_TOP;
	chartFrame.origin.y = YEARXYVAL_CONTENT_MARGIN_TOP;

	[self.chartContentView setFrame:chartFrame];
	[self.tabularDataView setFrame:chartFrame];
	
	
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
	if (fieldEnum == CPTBarPlotFieldBarLocation)
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
	return plotResult;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 28.0;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultsCell";

    YearValXYResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
        cell = [[[YearValXYResultsCell alloc] initWithFrame:CGRectZero] autorelease];
    }

	YearValPlotDataVal *plotDataVal = [currentData.plotData objectAtIndex:indexPath.row];
	
	SharedAppValues *sharedAppVals = [SharedAppValues 
			getUsingDataModelController:self.resultsViewInfo.simResultsController.dataModelController];
			
	NSNumber *plotResult;
	if([sharedAppVals.adjustResultsForSimStartDate boolValue])
	{
		plotResult = plotDataVal.inflationAdjustedVal;
	}
	else
	{
		plotResult = plotDataVal.unadjustedVal;
	}


        // Configure the cell.
	cell.year.text = [NSString stringWithFormat:@"%04d",[plotDataVal.year intValue]];
	cell.value.text = [[NumberHelper theHelper].currencyFormatterNoFraction 
				stringFromNumber:plotResult];

    return cell;


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [currentData.plotData count];
}

-(void)configureTableHeader:(UITableView *)tableView
{
	
	self.valColLabel.text = [self.plotDataGenerator dataLabel];
	self.valColLabel.textAlignment = UITextAlignmentCenter;
	
	CGSize maxSize = CGSizeMake(YEARVAL_RESULTS_CELL_COLUMN_WIDTH, 300);
	CGSize valueSize = [self.valColLabel.text sizeWithFont:self.valColLabel.font
						constrainedToSize:maxSize
						lineBreakMode:self.valColLabel.lineBreakMode];
	valueSize.height = MAX(valueSize.height, YEARVAL_RESULTS_CELL_HEIGHT);

	[self.valColLabel setFrame:CGRectMake(
		YEARVAL_RESULTS_CELL_VALUE_LEFT_OFFSET, 0, 
		YEARVAL_RESULTS_CELL_COLUMN_WIDTH, valueSize.height)];

	[yearColLabel sizeToFit];
	[self.yearColLabel setFrame:CGRectMake(
		YEARVAL_RESULTS_CELL_YEAR_LEFT_OFFSET, valueSize.height/2.0 - yearColLabel.frame.size.height/2.0, 
		YEARVAL_RESULTS_CELL_COLUMN_WIDTH, yearColLabel.frame.size.height)];
	self.yearColLabel.text = LOCALIZED_STR(@"RESULTS_YEAR_X_AXIS_TITLE");
	self.yearColLabel.textAlignment = UITextAlignmentCenter;

		
	[self.headerView setFrame:CGRectMake(0, 0, tableView.contentSize.width, valueSize.height)];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	[self configureTableHeader:tableView];
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	[self configureTableHeader:tableView];
	return self.headerView.frame.size.height;
}


-(void)dealloc
{
	[currentData release];
	[plotDataGenerator release];
	[chartContentView release];
	[resultsViewInfo release];
	[graphView release];
	[resultsTypeSelection release];
	[yearColLabel release];
	[valColLabel release];
	[headerView release];
	[tabularDataView release];
	[super dealloc];
}

@end
