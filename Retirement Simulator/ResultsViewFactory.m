//
//  ResultsViewFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewFactory.h"


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

-(UIViewController*)createTableView:(FormContext*)parentContext
{
	assert(0); // must be overridden
	return nil;

}

-(void)dealloc
{
	[resultsViewInfo release];
	[super dealloc];
}

@end
