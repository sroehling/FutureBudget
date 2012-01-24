//
//  HelpViewFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpViewFactory.h"
#import "HelpPageViewController.h"
#import "HelpPageInfo.h"

@implementation HelpViewFactory

@synthesize helpPageInfo;

-(id)initWithHelpPageInfo:(HelpPageInfo*)theHelpPageInfo
{
	self = [super init];
	if(self)
	{
		assert(theHelpPageInfo != nil);
		self.helpPageInfo = theHelpPageInfo;
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
	return [[[HelpPageViewController alloc] initWithHelpPageInfo:self.helpPageInfo] autorelease];
}

-(void)dealloc
{
	[super dealloc];
	[helpPageInfo release];
}


@end
