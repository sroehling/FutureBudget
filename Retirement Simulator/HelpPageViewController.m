//
//  HelpPageViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpPageViewController.h"
#import "HelpPageInfo.h"

@implementation HelpPageViewController

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

-(void)loadView
{
	[super loadView];
	
	UIWebView *helpPage = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
	helpPage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	
	NSString *path = [[NSBundle mainBundle] 
		pathForResource:helpPageInfo.helpPageHTML ofType:@"html"];
	NSURL *url = [NSURL fileURLWithPath:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[helpPage loadRequest:request];
		
	self.view = helpPage;

}

-(id)init
{
	assert(0);
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[helpPageInfo release];
}

@end
