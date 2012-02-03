//
//  TableHeaderWithDisclosure.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableHeaderWithDisclosure.h"
#import "TableHeaderDisclosureButtonDelegate.h"
#import "UIHelper.h"
#import "ColorHelper.h"

static CGFloat kLeftMargin = 10.0;
static CGFloat kRightMargin = 10.0;
static CGFloat kTopMargin = 4.0;
static CGFloat kBottomMargin = 4.0;
static CGFloat kLabelSpace = 4.0;
static CGFloat kButtonWidth = 20.0;
static CGFloat kButtonHeight = 20.0;


@implementation TableHeaderWithDisclosure

@synthesize header;
@synthesize disclosureButton;
@synthesize disclosureButtonDelegate;


- (id)initWithFrame:(CGRect)frame 
	andDisclosureButtonDelegate:(id<TableHeaderDisclosureButtonDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.header =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		self.header.backgroundColor = [UIColor clearColor];
        self.header.opaque = NO;
        self.header.textColor = [UIColor blackColor];
		self.header.textAlignment = UITextAlignmentCenter;
        self.header.highlightedTextColor = [UIColor whiteColor];
        self.header.font = [UIFont boldSystemFontOfSize:12];       
		[self addSubview:self.header];
		
		self.backgroundColor = [ColorHelper tableHeaderBackgroundColor];

		self.disclosureButtonDelegate = delegate;
		
		self.disclosureButton = [UIHelper imageButton:@"buttonDisclosure"];
		self.disclosureButton.hidden = FALSE;
        [self.disclosureButton addTarget:self.disclosureButtonDelegate 
				action:@selector(tableHeaderDisclosureButtonPressed) 
                     forControlEvents:UIControlEventTouchUpInside];
        // add button to right corner of section        
        [self addSubview:self.disclosureButton];
		


    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    assert(0);
	return nil;
}

- (id) init 
{
    assert(0);
	return nil;
}

- (void)resizeForChildren
{
	[self.header sizeToFit];   
	CGFloat headerHeight = MAX(CGRectGetHeight(self.header.bounds),
		CGRectGetHeight(self.disclosureButton.bounds));
	
	CGFloat newHeight = kTopMargin + headerHeight + kBottomMargin;
		
	CGRect frame = self.frame;
	frame.size.height = newHeight;
	self.frame = frame;
}

-(void) layoutSubviews {    
	
	[super layoutSubviews];    
	
	// Let the labels size themselves to accommodate their text    
	[self.header sizeToFit];      
	
	CGRect buttonFrame = self.disclosureButton.frame;
	buttonFrame.size.width = kButtonWidth;
	buttonFrame.size.height = kButtonHeight;
	buttonFrame.origin.x = CGRectGetMaxX(self.bounds)- kRightMargin-kButtonWidth;
	buttonFrame.origin.y = CGRectGetMidY(self.bounds)-CGRectGetHeight(buttonFrame)/2.0;;
	[self.disclosureButton setFrame:buttonFrame];

	
	// Position the labels at the top of the table cell    
	CGRect headerFrame = self.header.frame;    
	headerFrame.origin.x =CGRectGetMinX(self.bounds)+kLeftMargin;
	headerFrame.origin.y =CGRectGetMidY(self.bounds)-CGRectGetHeight(headerFrame)/2.0;
	headerFrame.size.width = CGRectGetWidth(self.bounds) - kButtonWidth - kRightMargin - kLabelSpace;
	[self.header setFrame: headerFrame];
	

	[self.disclosureButton setFrame:buttonFrame];
	
}


- (void)dealloc
{
    [super dealloc];
	[header release];
	[disclosureButton release];
	[disclosureButtonDelegate release];
}

@end
