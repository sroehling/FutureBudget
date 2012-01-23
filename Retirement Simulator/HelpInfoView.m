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
#import "UIHelper.h"


@implementation HelpInfoView


#define HELP_INFO_NAV_BAR_HEIGHT 40.0f

@synthesize helpInfo;
@synthesize navBar;
@synthesize helpInfoViewDelegate;
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
		UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithTitle:LOCALIZED_STR(@"HELP_INFO_VIEW_DONE_BUTTON_LABEL") 
			style:UIBarButtonSystemItemDone target:self action:@selector(helpInfoViewDone)] autorelease];
		UINavigationItem *item = [[[UINavigationItem alloc] initWithTitle:nil] autorelease];
		item.rightBarButtonItem = rightButton;
		item.hidesBackButton = YES;
			
		self.navBarTitle = [UIHelper titleForNavBar];

		self.navBarTitle.text = @"TBD";
		[self.navBarTitle sizeToFit];
		
        item.titleView = self.navBarTitle;			
			
		[self.navBar pushNavigationItem:item animated:NO];
		
		self.helpInfo = [[[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)] autorelease];
		[self addSubview:self.helpInfo];
		

    }
    return self;
}

- (IBAction)helpInfoViewDone 
{
	
	NSLog(@"Help Info view done");
	assert(helpInfoViewDelegate != nil);
	[self.helpInfoViewDelegate helpInfoViewDone];
}


-(void) layoutSubviews {    
	
	[super layoutSubviews];
	
	self.navBar.frame = CGRectMake(0.0f,0.0f,CGRectGetWidth(self.bounds), HELP_INFO_NAV_BAR_HEIGHT);
	self.helpInfo.frame = CGRectMake(0.0f, HELP_INFO_NAV_BAR_HEIGHT, CGRectGetWidth(self.bounds), 
		CGRectGetHeight(self.bounds)-HELP_INFO_NAV_BAR_HEIGHT);

	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	NSString *html = [self.helpInfoViewDelegate helpInfoHTML];
	assert(html != nil);  
	[self.helpInfo loadHTMLString:html baseURL:baseURL];
	
	self.navBarTitle.text = [self.helpInfoViewDelegate helpTitle];
	[self.navBarTitle sizeToFit];

}



- (void)dealloc
{
    [super dealloc];
	[helpInfo release];
	[navBar release];
	[navBarTitle release];
}

@end
