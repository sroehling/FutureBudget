//
//  HelpInfoView.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpInfoView.h"
#import "ColorHelper.h"
#import "LocalizationHelper.h"
#import "HelpFlipViewInfo.h"
#import "UIHelper.h"

#import "StringValidation.h"

@implementation HelpInfoView


#define HELP_INFO_NAV_BAR_HEIGHT 40.0f

@synthesize helpInfo;
@synthesize navBar;
@synthesize helpFlipViewInfo;
@synthesize navBarTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.helpInfo = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor viewFlipsideBackgroundColor];  
		
		self.navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)] autorelease];
		self.navBar.tintColor = [ColorHelper navBarTintColor];
		[self addSubview:navBar];
		UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithTitle:LOCALIZED_STR(@"HELP_INFO_VIEW_DONE_BUTTON_LABEL") 
			style:UIBarButtonSystemItemDone target:self action:@selector(helpInfoViewDone)] autorelease];
		UINavigationItem *item = [[[UINavigationItem alloc] initWithTitle:nil] autorelease];
		item.leftBarButtonItem = doneButton;
		item.hidesBackButton = YES;
			
		self.navBarTitle = [UIHelper titleForNavBar];

		self.navBarTitle.text = @"";
		[self.navBarTitle sizeToFit];
		
        item.titleView = self.navBarTitle;			
			
		[self.navBar pushNavigationItem:item animated:NO];
		
		self.helpInfo = [[[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)] autorelease];
		[self addSubview:self.helpInfo];
		
		// TBD - The code below is essentially duplicated in HelpPageViewController. Is
		// this block of code a candidate for a common/helper method?
		
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
		spacer.width = 2.0f;
		[buttons addObject:spacer];
		
		// Add a forward button.
		UIBarButtonItem *fwdButton = [[[UIBarButtonItem alloc] initWithTitle:@"▶" 
				style:UIBarButtonItemStyleBordered target:self action:@selector(helpPageFwd)] autorelease];
		[buttons addObject:fwdButton];

		// Add buttons to toolbar and toolbar to nav bar.
		[tools setItems:buttons animated:NO];
		UIBarButtonItem *twoButtons = [[[UIBarButtonItem alloc] initWithCustomView:tools] autorelease];


		item.rightBarButtonItem = twoButtons;

		

    }
    return self;
}

- (IBAction)helpInfoViewDone 
{
	
	NSLog(@"Help Info view done");
	[self.helpFlipViewInfo.parentController dismissModalViewControllerAnimated:YES];

}


-(void) layoutSubviews {    
	
	[super layoutSubviews];
	
	assert(self.helpFlipViewInfo != nil);
	
	self.navBar.frame = CGRectMake(0.0f,0.0f,CGRectGetWidth(self.bounds), HELP_INFO_NAV_BAR_HEIGHT);
	self.helpInfo.frame = CGRectMake(0.0f, HELP_INFO_NAV_BAR_HEIGHT, CGRectGetWidth(self.bounds), 
		CGRectGetHeight(self.bounds)-HELP_INFO_NAV_BAR_HEIGHT);

	assert([StringValidation nonEmptyString:self.helpFlipViewInfo.helpPageHTMLFile]);
	NSString *path = [[NSBundle mainBundle] 
		pathForResource:self.helpFlipViewInfo.helpPageHTMLFile ofType:@"html"];
	assert(path != nil); // could be nil if file doesn't exist (an error in the "coding" of the help files)
	NSURL *url = [NSURL fileURLWithPath:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.helpInfo loadRequest:request];
	
	[self.navBarTitle sizeToFit];

}

-(void)helpPageBack
{
	if([self.helpInfo canGoBack])
	{
		[self.helpInfo goBack];
	}
}

-(void)helpPageFwd
{
	if([self.helpInfo canGoForward])
	{
		[self.helpInfo goForward];
	}
}




- (void)dealloc
{
    [super dealloc];
	[helpInfo release];
	[helpFlipViewInfo release];
	[navBar release];
	[navBarTitle release];
}

@end
