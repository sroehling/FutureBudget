//
//  TextCaptionWEPopoverContainer.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TextCaptionWEPopoverContainer.h"
#import "WEPopoverContainerView.h"
#import "UIHelper.h"
#import "StringValidation.h"


@implementation TextCaptionWEPopoverContainer

@synthesize captionText;

- (WEPopoverContainerViewProperties *)containerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[[WEPopoverContainerViewProperties alloc] init] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"popoverBg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
	bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = contentMargin; 
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;	
}


- (id)initWithCaption:(NSString*)theCaptionText {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super init])) {
		CGFloat width = 150;
		CGFloat height = 150;
		self.contentSizeForViewInPopover = CGSizeMake(width, height);
		
		[StringValidation nonEmptyString:theCaptionText];
		self.captionText = theCaptionText;
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
	[captionText release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

	UILabel *popoverCaption = [[[UILabel alloc] init] autorelease];
	popoverCaption.text = self.captionText;
	popoverCaption.lineBreakMode = UILineBreakModeWordWrap;
	popoverCaption.numberOfLines = 0;
	popoverCaption.backgroundColor = [UIColor clearColor];
	popoverCaption.textColor = [UIColor whiteColor];
	popoverCaption.font = [UIFont systemFontOfSize:14.0];

	CGFloat kPopoverWidth = 150;
	
	CGFloat captionHeight = [UIHelper labelHeight:popoverCaption 
		forWidth:kPopoverWidth andLeftMargin:2 andRightMargin:2];
	CGRect newFrame = popoverCaption.frame;
	newFrame.size.width = kPopoverWidth;
	newFrame.size.height = captionHeight;
	newFrame.origin.x = 0;
	newFrame.origin.y = 0;
	[popoverCaption setFrame:newFrame];
	
	[self.view addSubview:popoverCaption];

	self.contentSizeForViewInPopover = CGSizeMake(kPopoverWidth, captionHeight - 1);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
