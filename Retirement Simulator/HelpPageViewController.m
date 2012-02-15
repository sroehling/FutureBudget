//
//  HelpPageViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpPageViewController.h"
#import "HelpPageInfo.h"
#import "ColorHelper.h"

@implementation HelpPageViewController

@synthesize helpPageInfo;
@synthesize helpPage;

-(id)initWithHelpPageInfo:(HelpPageInfo*)theHelpPageInfo
{
	self = [super init];
	if(self)
	{
		assert(theHelpPageInfo != nil);
		self.helpPageInfo = theHelpPageInfo;

		self.helpPage = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
		self.helpPage.autoresizingMask = UIViewAutoresizingFlexibleHeight | 
					UIViewAutoresizingFlexibleWidth;
					
			

		UIToolbar *tools = [[[UIToolbar alloc]
						initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 44.01f)] autorelease]; // 44.01 shifts it up 1px for some reason
		tools.clearsContextBeforeDrawing = NO;
		tools.clipsToBounds = NO;
		tools.tintColor = [ColorHelper navBarTintColor];
		tools.barStyle = -1; // clear background
		NSMutableArray *buttons = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];

		UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:@"◀" 
				style:UIBarButtonItemStyleBordered target:self action:@selector(helpPageBack)] autorelease];
		[buttons addObject:backButton];


		// Create a spacer.
		UIBarButtonItem *spacer = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
		spacer.width = 4.0f;
		[buttons addObject:spacer];
		
		// Add a forward button.
		UIBarButtonItem *fwdButton = [[[UIBarButtonItem alloc] initWithTitle:@"▶" 
				style:UIBarButtonItemStyleBordered target:self action:@selector(helpPageFwd)] autorelease];
		[buttons addObject:fwdButton];

		// Add buttons to toolbar and toolbar to nav bar.
		[tools setItems:buttons animated:NO];
		UIBarButtonItem *twoButtons = [[[UIBarButtonItem alloc] initWithCustomView:tools] autorelease];


		self.navigationItem.rightBarButtonItem = twoButtons;
			

	}
	return self;
}

-(void)helpPageBack
{
	if([self.helpPage canGoBack])
	{
		[self.helpPage goBack];
	}
}

-(void)helpPageFwd
{
	if([self.helpPage canGoForward])
	{
		[self.helpPage goForward];
	}
}

-(void)loadView
{
	[super loadView];
	
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
	[helpPageInfo release];
	[helpPage release];
	[super dealloc];
}

@end
