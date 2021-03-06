//
//  ResultsViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultsViewInfo.h"
#import "UIHelper.h"

@implementation ResultsViewController

@synthesize viewInfo;

-(id)initWithResultsViewInfo:(ResultsViewInfo*)theViewInfo
{
	self = [super init];
	if(self)
	{
		assert(theViewInfo != nil);
		self.viewInfo = theViewInfo;

		self.title = self.viewInfo.viewTitle;
	}
	return self;
}

- (void)setTitle:(NSString *)title
{
	[super setTitle:title];
	[UIHelper setCommonTitleForController:self withTitle:title];
}


-(id)init
{
	assert(0); // must init with SimResultsController
	return nil;
}

- (void)dealloc
{
	[viewInfo release];
    [super dealloc];
}


@end
