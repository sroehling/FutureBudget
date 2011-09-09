//
//  SectionHeaderWithSubtitle.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SectionHeaderWithSubtitle.h"

#define CUSTOM_SECTION_VIEW_LEFT_LABEL_OFFSET 15.0
#define CUSTOM_SECTION_VIEW_RIGHT_LABEL_OFFSET 10.0
#define CUSTOM_SECTION_VIEW_TITLE_HEIGHT 22.0
#define CUSTOM_SECTION_VIEW_SUBTITLE_TOP (CUSTOM_SECTION_VIEW_TITLE_HEIGHT+2.0)
#define CUSTOM_SECTION_VIEW_SUBTITLE_HEIGHT 20.0
#define CUSTOM_SECTION_FIXED_HEIGHT (CUSTOM_SECTION_VIEW_TITLE_HEIGHT + 2.0)

#define CUSTOM_SECTION_INFO_BUTTON_WIDTH 50.0
#define ADD_OBJECT_BUTTON_WIDTH 50.0


@implementation SectionHeaderWithSubtitle

@synthesize headerLabel;
@synthesize subtitle;
@synthesize infoButton;
@synthesize addButton;
@synthesize addButtonDelegate;

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
	   
	
		self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
		self.backgroundColor = [UIColor clearColor];
		[self addSubview:self.headerLabel];

		self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
		[infoButton addTarget:self action:@selector(showInfoPopup) 
                     forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:infoButton];
		
		
		self.addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.addButton setTitle:@"Add" forState:UIControlStateNormal];
		[self addSubview:addButton];
		[self.addButton addTarget:self action:@selector(addButtonPressed) 
                     forControlEvents:UIControlEventTouchUpInside];
		self.addButton.hidden = TRUE;

		self.addButtonDelegate = nil;



    }
    return self;
}

- (BOOL)showInfoButton
{
	return ((self.subtitle!=nil) && ([self.subtitle length] > 0))?TRUE:FALSE;
}

-(CGFloat)rightOffsetForEditMode:(BOOL)editing
{
	if(editing)
	{
		if(self.addButtonDelegate != nil)
		{
			return ADD_OBJECT_BUTTON_WIDTH;
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
	
	
	self.addButton.frame = CGRectMake(tableWidth-ADD_OBJECT_BUTTON_WIDTH, 0.0, 
                     ADD_OBJECT_BUTTON_WIDTH, CUSTOM_SECTION_FIXED_HEIGHT);
	self.infoButton.frame = CGRectMake(tableWidth-CUSTOM_SECTION_INFO_BUTTON_WIDTH, 0.0, 
					CUSTOM_SECTION_INFO_BUTTON_WIDTH, CUSTOM_SECTION_VIEW_TITLE_HEIGHT);
	[self updatedAddButtonVisibility:editing];
	[self updateInfoButtonVisibility:editing];
	
	[self setFrame:headerSize];	
		

}

- (void)addButtonPressed
{
    assert(addButtonDelegate != nil);
	[self.addButtonDelegate addButtonPressedInSectionHeader];
}

-(void)showInfoPopup
{
	UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@""
	message:self.subtitle
	delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[av show];

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
	[subtitle release];
	[infoButton release];
	
	[addButton release];
	[addButtonDelegate release];
}

@end
