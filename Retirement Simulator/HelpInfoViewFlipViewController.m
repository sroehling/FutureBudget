//
//  HelpInfoViewFlipViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpInfoViewFlipViewController.h"
#import "HelpInfoView.h"

@protocol HelpInfoViewControllerDelegate;

@implementation HelpInfoViewFlipViewController

@synthesize helpInfoView;
@synthesize helpDoneDelegate;

- (id)initWithHelpInfoDoneDelegate:(id<HelpInfoViewDelegate>)helpInfoDoneDel
{
	self = [super init];
	if(self)
	{
		assert(helpInfoDoneDel != nil);
		self.helpDoneDelegate = helpInfoDoneDel;
		self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.helpInfoView = [[[HelpInfoView alloc] initWithFrame:CGRectZero] autorelease];
	self.helpInfoView.helpInfoViewDelegate = self.helpDoneDelegate;
	self.view = self.helpInfoView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end