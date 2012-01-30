//
//  HelpInfoViewFlipViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpInfoViewFlipViewController.h"
#import "HelpInfoView.h"
#import "HelpFlipViewInfo.h"

@protocol HelpInfoViewControllerDelegate;

@implementation HelpInfoViewFlipViewController

@synthesize helpInfoView;
@synthesize helpFlipViewInfo;

- (id)initWithHelpFlipViewInfo:(HelpFlipViewInfo*)theHelpFlipViewInfo
{
	self = [super init];
	if(self)
	{
		assert(theHelpFlipViewInfo != nil);
		self.helpFlipViewInfo = theHelpFlipViewInfo;
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
	[helpFlipViewInfo release];
	[helpInfoView release];
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
	self.helpInfoView.helpFlipViewInfo = self.helpFlipViewInfo;
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