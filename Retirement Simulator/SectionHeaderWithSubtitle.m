//
//  SectionHeaderWithSubtitle.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SectionHeaderWithSubtitle.h"
#import "AlertViewHelper.h"
#import "HelpInfoViewFlipViewController.h"
#import "HelpFlipViewInfo.h"
#import "StringValidation.h"
#import "UIHelper.h"

#define CUSTOM_SECTION_VIEW_LEFT_LABEL_OFFSET 15.0
#define CUSTOM_SECTION_VIEW_RIGHT_LABEL_OFFSET 10.0
#define CUSTOM_SECTION_VIEW_TITLE_HEIGHT 22.0
#define CUSTOM_SECTION_VIEW_SUBTITLE_TOP (CUSTOM_SECTION_VIEW_TITLE_HEIGHT+2.0)
#define CUSTOM_SECTION_VIEW_SUBTITLE_HEIGHT 20.0
#define CUSTOM_SECTION_FIXED_HEIGHT (CUSTOM_SECTION_VIEW_TITLE_HEIGHT + 2.0)

#define CUSTOM_SECTION_INFO_BUTTON_WIDTH 20.0
#define CUSTOM_SECTION_INFO_BUTTON_HEIGHT 20.0
#define CUSTOM_SECTION_INFO_BUTTON_RIGHT_OFFSET 10.0


@implementation SectionHeaderWithSubtitle

@synthesize headerLabel;
@synthesize helpInfoHTMLFile;
@synthesize infoButton;
@synthesize addButton;
@synthesize addButtonDelegate;
@synthesize parentController;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.headerLabel.backgroundColor = [UIColor clearColor];
        self.headerLabel.opaque = NO;
        self.headerLabel.textColor = [UIColor blackColor];
        self.headerLabel.highlightedTextColor = [UIColor whiteColor];
        self.headerLabel.font = [UIFont boldSystemFontOfSize:14];	
	   
		self.backgroundColor = [UIColor clearColor];
		[self addSubview:self.headerLabel];
		
		self.infoButton = [UIHelper imageButton:@"buttonhelp"];
		[infoButton addTarget:self action:@selector(showInfoPopup) 
                     forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:infoButton];
		
		
		self.addButton = [UIHelper imageButton:@"buttonadd"];
		[self.addButton addTarget:self action:@selector(addButtonPressed) 
                     forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:addButton];
		self.addButton.hidden = TRUE;

		self.addButtonDelegate = nil;
    }
    return self;
}

- (BOOL)showInfoButton
{
	return [StringValidation nonEmptyString:self.helpInfoHTMLFile];
}

-(CGFloat)rightOffsetForEditMode:(BOOL)editing
{
	if(editing)
	{
		if(self.addButtonDelegate != nil)
		{
			return CUSTOM_SECTION_INFO_BUTTON_WIDTH;
		}
		else
		{
			return 0.0;
		}
	}
	else
	{
		if([self showInfoButton])
		{
			return CUSTOM_SECTION_INFO_BUTTON_WIDTH;
		}
		else
		{
			return 0.0;
		}
	}
}

- (void)updatedAddButtonVisibility:(BOOL)editing
{
	if(editing && (self.addButtonDelegate != nil))
	{
		self.addButton.hidden = FALSE;
	}
	else
	{
		self.addButton.hidden = TRUE;
	}
}



- (void)updateInfoButtonVisibility:(BOOL)editing
{
	if(editing)
    {
		infoButton.hidden = TRUE;

	}
	else
	{
		if([self showInfoButton])
        {
			// add button to right corner of section        
			infoButton.hidden = FALSE;
		}
		else
		{
			infoButton.hidden = TRUE;
		}
    }

}

-(void)sizeForTableWidth:(CGFloat)tableWidth andEditMode:(BOOL)editing
{
	CGFloat labelWidth = tableWidth - CUSTOM_SECTION_VIEW_LEFT_LABEL_OFFSET - CUSTOM_SECTION_VIEW_RIGHT_LABEL_OFFSET - [self rightOffsetForEditMode:editing];
		
	headerLabel.frame = CGRectMake(CUSTOM_SECTION_VIEW_LEFT_LABEL_OFFSET, 0.0, labelWidth, CUSTOM_SECTION_VIEW_TITLE_HEIGHT);
	CGRect headerSize = self.bounds;
	headerSize.size.width = tableWidth - 20.0;
	headerSize.size.height = CUSTOM_SECTION_FIXED_HEIGHT;
	
	CGRect buttonFrame = CGRectMake(
		tableWidth-CUSTOM_SECTION_INFO_BUTTON_WIDTH-CUSTOM_SECTION_INFO_BUTTON_RIGHT_OFFSET, 1.0, 
		CUSTOM_SECTION_INFO_BUTTON_WIDTH, CUSTOM_SECTION_INFO_BUTTON_HEIGHT);
	
	self.addButton.frame = buttonFrame;
	self.infoButton.frame = buttonFrame;
	[self updatedAddButtonVisibility:editing];
	[self updateInfoButtonVisibility:editing];
	
	[self setFrame:headerSize];	
		

}

- (void)addButtonPressed
{
    assert(addButtonDelegate != nil);
	[self.addButtonDelegate addButtonPressedInSectionHeader:self.parentController];
}

-(void)showInfoPopup
{
	// parent controller must be set if the info popup is 
	// used.
	assert(self.parentController != nil);
	assert(self.helpInfoHTMLFile != nil);
	HelpFlipViewInfo *flipViewInfo = [[[HelpFlipViewInfo alloc] 
			initWithParentController:self.parentController 
			andHelpPageHTMLFile:self.helpInfoHTMLFile] autorelease];
	
	HelpInfoViewFlipViewController *helpInfoViewController = [[[HelpInfoViewFlipViewController alloc] 
		initWithHelpFlipViewInfo:flipViewInfo] autorelease];
	[parentController presentModalViewController:helpInfoViewController animated:TRUE];
}


-(void)layoutSubviews
{
	[super layoutSubviews];
	
}

-(CGFloat)headerHeight
{
    return CUSTOM_SECTION_FIXED_HEIGHT + subtitleHeight;
}


- (void)dealloc
{
    [super dealloc];
	[headerLabel release];
	[infoButton release];
	[helpInfoHTMLFile release];
	[addButton release];
	[addButtonDelegate release];
}

@end
