//
//  ValueSubtitleTableCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ValueSubtitleTableCell.h"


@implementation ValueSubtitleTableCell

static CGFloat kLeftMargin = 10.0;
static CGFloat kRightMargin = 10.0;
static CGFloat kTopMargin = 5.0;
static CGFloat kBottomMargin = 5.0;
static CGFloat kLabelSpace = 2.0;

@synthesize valueDescription;
@synthesize valueSubtitle;
@synthesize caption;

- (id) initWithFrame:(CGRect)frame
{
	self =[super initWithFrame: frame];
	if(self)
	{        
		self.caption =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		self.caption.backgroundColor = [UIColor clearColor];
        self.caption.opaque = NO;
        self.caption.textColor = [UIColor blackColor];
		self.caption.textAlignment = UITextAlignmentLeft;
        self.caption.highlightedTextColor = [UIColor whiteColor];
        self.caption.font = [UIFont boldSystemFontOfSize:14];       
		
		[self.contentView addSubview: self.caption];        
		
		self.valueDescription =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];        
		self.valueDescription.backgroundColor = [UIColor clearColor];
        self.valueDescription.opaque = NO;
        self.valueDescription.textColor = [UIColor blackColor];
		self.valueDescription.textAlignment = UITextAlignmentRight;
        self.valueDescription.highlightedTextColor = [UIColor whiteColor];
        self.valueDescription.font = [UIFont systemFontOfSize:14];       
		
		[self.contentView addSubview: self.valueDescription];    
		
		self.valueSubtitle =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease]; 
		self.valueSubtitle.backgroundColor = [UIColor clearColor];
        self.valueSubtitle.opaque = NO;
 		self.valueSubtitle.textAlignment = UITextAlignmentLeft;
		self.valueSubtitle.textColor = [UIColor grayColor];
        self.valueSubtitle.highlightedTextColor = [UIColor whiteColor];
        self.valueSubtitle.font = [UIFont systemFontOfSize:10]; 
		
		[self.contentView addSubview: self.valueSubtitle];    
		
		self.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		
		
	}    
	return self;
}

- (CGFloat)cellHeight
{
	[caption sizeToFit];    
	[valueDescription sizeToFit];  
	[valueSubtitle sizeToFit];

	CGFloat cellHeight = kTopMargin;
	cellHeight += CGRectGetHeight(self.valueDescription.bounds);
	if([valueSubtitle.text length] > 0)
	{
		cellHeight += kLabelSpace;
		cellHeight += CGRectGetHeight(self.valueSubtitle.bounds);
	}		
	cellHeight += kBottomMargin;
	
	return cellHeight;
}

-(void) layoutSubviews {    
	
	[super layoutSubviews];    
	
	// Let the labels size themselves to accommodate their text    
	[caption sizeToFit];    
	[valueDescription sizeToFit];  
	[valueSubtitle sizeToFit];
	
	// Position the labels at the top of the table cell    
	CGRect newFrame = caption.frame;    
	newFrame.origin.x =CGRectGetMinX(self.contentView.bounds)+kLeftMargin;
	newFrame.origin.y =CGRectGetMinY(self.contentView.bounds)+kTopMargin;
	[caption setFrame: newFrame];    
	
  
	newFrame = valueDescription.frame; 
	newFrame.origin.x = CGRectGetMaxX(self.contentView.bounds)-kRightMargin-
		CGRectGetWidth(valueDescription.frame);  
	newFrame.origin.y =CGRectGetMinY(self.contentView.bounds)+kTopMargin;    
	[valueDescription setFrame: newFrame];
	
	newFrame = valueSubtitle.frame;
	newFrame.origin.x = CGRectGetMaxX(self.contentView.bounds)-kRightMargin-
		CGRectGetWidth(valueSubtitle.frame);  
	newFrame.origin.y =CGRectGetMaxY(self.valueDescription.frame)+kLabelSpace; 
	[valueSubtitle setFrame:newFrame];   
	
}

- (void)dealloc
{
    [super dealloc];
	[valueDescription release];
	[valueSubtitle release];
	[caption release];

}

@end
