//
//  ValueSubtitleTableCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ValueSubtitleTableCell.h"
#import "ColorHelper.h"
#import "TableCellHelper.h"

@implementation ValueSubtitleTableCell

@synthesize valueDescription;
@synthesize valueSubtitle;
@synthesize caption;
@synthesize supportsDelete;

- (id) initWithFrame:(CGRect)frame
{
	self =[super initWithFrame: frame];
	if(self)
	{        
		self.caption = [TableCellHelper createLabel];       
		[self.contentView addSubview: self.caption];        
		
		self.valueDescription =[TableCellHelper createNonEditableBlueValueLabel];
		[self.contentView addSubview: self.valueDescription];    
		
		self.valueSubtitle = [TableCellHelper createSubtitleLabel];
		[self.contentView addSubview: self.valueSubtitle];    
		
		self.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		self.supportsDelete = FALSE;
	}    
	return self;
}

- (CGFloat)cellHeight
{
	[caption sizeToFit];    
	[valueDescription sizeToFit];  
	[valueSubtitle sizeToFit];

	CGFloat cellHeight = TABLE_CELL_TOP_MARGIN;
	
	cellHeight += MAX(CGRectGetHeight(self.valueDescription.bounds),
					  CGRectGetHeight(self.caption.bounds));
	if([valueSubtitle.text length] > 0)
	{
		cellHeight += TABLE_CELL_CHILD_SPACE;
		cellHeight += CGRectGetHeight(self.valueSubtitle.bounds);
	}		
	cellHeight += TABLE_CELL_BOTTOM_MARGIN;
	
	// If the cell is used for an object that can be deleted,
	// the overall height of the cell needs to be enough to show the delete button
	if(self.supportsDelete)
	{
		cellHeight = MAX(cellHeight, TABLE_CELL_MIN_OVERALL_HEIGHT_TO_SUPPORT_DELETE);
	}
	
	return cellHeight;
}

-(void) layoutSubviews {    
	
	[super layoutSubviews];    
	
	// Let the labels size themselves to accommodate their text    
	[caption sizeToFit];    
	[valueDescription sizeToFit];  
	[valueSubtitle sizeToFit];
	
	// Position the labels at the top of the table cell
	// TODO - Center everything in the middle of the cell, especially  if
	// the supportsDelete flag is set.   
	[TableCellHelper topLeftAlignChild:caption withinParentFrame:self.contentView.bounds];
	[TableCellHelper topRightAlignChild:valueDescription withinParentFrame:self.contentView.bounds];
	
	CGRect newFrame = valueSubtitle.frame;
	newFrame.origin.x = CGRectGetMaxX(self.contentView.bounds)-TABLE_CELL_RIGHT_MARGIN-
		CGRectGetWidth(valueSubtitle.frame);  
	newFrame.origin.y =CGRectGetMaxY(self.valueDescription.frame)+TABLE_CELL_CHILD_SPACE; 
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
