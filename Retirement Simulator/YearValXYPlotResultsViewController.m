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


#import "SimResultsController.h"
#import "SimResults.h"
#import "StringValidation.h"
#import "ResultsViewInfo.h"
#import "YearValXYPlotData.h"
#import "YearValXYPlotDataGenerator.h"
#import "SharedAppValues.h"
#import "YearValPlotDataVal.h"
#import "YearValXYResultsView.h"


@implementation YearValXYPlotResultsViewController

@synthesize simProgressHUD;
@synthesize resultsView;
@synthesize plotDataGenerator;


-(id)initWithResultsViewInfo:(ResultsViewInfo *)theViewInfo 
	andPlotDataGenerator:(id<YearValXYPlotDataGenerator>)thePlotDataGenerator
{
	self = [super initWithResultsViewInfo:theViewInfo];
	if(self) 
	{
		self.resultsView = [[[YearValXYResultsView alloc] initWithResultsViewInfo:theViewInfo andPlotDataGenerator:thePlotDataGenerator] autorelease];
		self.plotDataGenerator = thePlotDataGenerator;
		self.view = self.resultsView;
	}
	return self;
}

-(id)initWithResultsViewInfo:(ResultsViewInfo *)theViewInfo
{
	assert(0);
	return nil;
}


- (void)dealloc
{
	[simProgressHUD release];
	[plotDataGenerator release];
	[super dealloc];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

-(void)generateResults
{
    
    // TODO - Need to rethink how we hold onto the simResults and
    // verify the results are current
    assert(!self.viewInfo.simResultsController.resultsOutOfDate);
    SimResults *simResults = self.viewInfo.simResultsController.currentSimResults;
    assert(simResults != nil);
    [[simResults retain] autorelease];

    
	if([self.plotDataGenerator resultsDefinedInSimResults:simResults])
	{
		[self.resultsView generateResults];
	}
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

- (void)hudWasHidden:(MBProgressHUD *)hud 
{
	// Remove HUD from screen when the HUD was hidden
	[hud removeFromSuperview];
	[self generateResults];

}
#pragma mark ProgressUpdateDelegate

-(void)updateProgress:(CGFloat)currentProgress
{
	assert(self.simProgressHUD != nil);
	self.simProgressHUD.progress = currentProgress;
}

#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];	

    // TODO - Need to trigger the generation of results from SimResultsController
    
	if(!self.viewInfo.simResultsController.resultsOutOfDate)
	{
		[self generateResults];
	}
}

-(void)generateSimResults
{
	self.simProgressHUD = [[[MBProgressHUD alloc] 
			initWithView:self.navigationController.view] autorelease];

	[self.navigationController.view addSubview:self.simProgressHUD];
	
	self.simProgressHUD.dimBackground = YES;
	self.simProgressHUD.mode = MBProgressHUDModeDeterminate;
	
	self.simProgressHUD.labelText = LOCALIZED_STR(@"RESULTS_PROGRESS_LABEL");
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	self.simProgressHUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[self.simProgressHUD showWhileExecuting:@selector(runSimulatorForResults:) 
			onTarget:self.viewInfo.simResultsController withObject:self animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
	
	[super viewDidAppear:animated];
	
	if(self.viewInfo.simResultsController.resultsOutOfDate)
	{
		[self generateSimResults];
	}
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
