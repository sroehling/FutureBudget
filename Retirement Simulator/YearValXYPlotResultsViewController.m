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
@synthesize currentSimResults;


-(id)initWithResultsViewInfo:(ResultsViewInfo *)theViewInfo 
	andPlotDataGenerator:(id<YearValXYPlotDataGenerator>)thePlotDataGenerator
{
	self = [super initWithResultsViewInfo:theViewInfo];
	if(self) 
	{
		self.resultsView = [[[YearValXYResultsView alloc] initWithResultsViewInfo:theViewInfo andPlotDataGenerator:thePlotDataGenerator] autorelease];
		self.plotDataGenerator = thePlotDataGenerator;
		self.view = self.resultsView;
        
        self.currentSimResults = [SimResultsController theSimResultsController].currentSimResults;
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
    
    assert(self.currentSimResults != nil);
    
	if([self.plotDataGenerator resultsDefinedInSimResults:self.currentSimResults])
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

-(void)showSimProgressHUD
{
    self.simProgressHUD = [[[MBProgressHUD alloc]
                            initWithView:self.navigationController.view] autorelease];
    self.simProgressHUD.dimBackground = YES;
    self.simProgressHUD.mode = MBProgressHUDModeDeterminate;
    self.simProgressHUD.labelText = LOCALIZED_STR(@"RESULTS_PROGRESS_LABEL");
    
    [self.navigationController.view addSubview:self.simProgressHUD];
    [self.simProgressHUD show:TRUE];
}

- (void)updateSimProgress:(NSNotification *)progressInfo
{
    if(self.simProgressHUD == nil)
    {
        [self showSimProgressHUD];
    }
    self.simProgressHUD.progress = [SimResultsController progressValFromSimProgressUpdate:progressInfo];
}

-(void)updatedSimResultsAvailable:(NSNotification*)resultsInfo
{
    self.currentSimResults = [SimResultsController theSimResultsController].currentSimResults;
    
    [self.simProgressHUD removeFromSuperview];
    self.simProgressHUD = nil;
    
    [self generateResults];
}

#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];	

    [[NSNotificationCenter defaultCenter] addObserver:self
          selector:@selector(updateSimProgress:)
          name:SIM_RESULTS_PROGRESS_NOTIFICATION_NAME object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(updatedSimResultsAvailable:)
        name:SIM_RESULTS_NEW_RESULTS_AVAILABLE_NOTIFICATION_NAME object:nil];

	if(self.currentSimResults != nil)
	{
		[self generateResults];
	}
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
