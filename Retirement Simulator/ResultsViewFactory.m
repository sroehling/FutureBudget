//
//  ResultsViewFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewFactory.h"
#import "ResultsViewController.h"


@implementation ResultsViewFactory

@synthesize resultsViewInfo;

-(id)initWithResultsViewInfo:(ResultsViewInfo*)theResultsViewInfo
{
	self = [super init];
	if(self)
	{
		assert(theResultsViewInfo != nil);
		self.resultsViewInfo = theResultsViewInfo;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

- (UIViewController*)createTableView
{
	assert(0); // must be overridden
	return nil;

}

-(void)dealloc
{
	[super dealloc];
	[resultsViewInfo release];
}

@end
