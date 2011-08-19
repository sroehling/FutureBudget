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

@implementation ResultsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Results";
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Simulator interface

- (void) runSimulatorForResults
{
     
    NSLog(@"Starting simulation run...");
    
    SimEngine *simEngine = [[SimEngine alloc] init ];
           
    [simEngine runSim];
    
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
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
