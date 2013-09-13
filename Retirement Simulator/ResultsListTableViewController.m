//
//  ResultsListTableViewController.m
//  FutureBudget
//
//  Created by Steve Roehling on 9/11/13.
//
//

#import "ResultsListTableViewController.h"
#import "SimResultsController.h"
#import "MBProgressHUD.h"
#import "LocalizationHelper.h"

@implementation ResultsListTableViewController

@synthesize simProgressHUD;

-(void)dealloc
{
    [simProgressHUD release];
    [super dealloc];
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
    [self.simProgressHUD removeFromSuperview];
    self.simProgressHUD = nil;
    
    [self reloadTableView];
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

@end
