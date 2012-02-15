//
//  FormFieldWithSubtitleTableCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FormFieldWithSubtitleTableCell.h"
#import "ColorHelper.h"
#import "TableCellHelper.h"

@implementation FormFieldWithSubtitleTableCell

@synthesize contentDescription;
@synthesize subTitle;
@synthesize caption;


- (id) initWithFrame:(CGRect)frame
{
	self =[super initWithFrame: frame];
	if(self)
	{        
		self.caption =[TableCellHelper createLabel];      
		[self.contentView addSubview: self.caption];        
		
		self.contentDescription =[TableCellHelper createNonEditableBlueValueLabel];        
		[self.contentView addSubview: self.contentDescription];
		
		self.subTitle = [TableCellHelper createWrappedSubtitleLabel];
		[self.contentView addSubview: self.subTitle];
		
	}    
	return self;
}


- (CGFloat)subTitleWidthWithMargin
{
	CGSize constraintSize =CGSizeMake([UIScreen mainScreen].bounds.size.width-TABLE_CELL_SCREEN_MARGIN, MAXFLOAT);
	CGFloat overallWidth = constraintSize.width;
	return overallWidth - TABLE_CELL_LEFT_MARGIN - TABLE_CELL_RIGHT_MARGIN - TABLE_CELL_DISCLOSURE_WIDTH;
}

- (CGFloat)subTitleHeight
{
	// TODO - Migrate to use code in UIHelper
	if([self.subTitle.text length] == 0)
	{
		return 0.0;
	}
	else
	{
		CGFloat subTitleWidth = [self subTitleWidthWithMargin];
		
		CGSize maxSize = CGSizeMake(subTitleWidth, 300);
		
		CGSize subTitleSize = [self.subTitle.text sizeWithFont:self.subTitle.font
											 constrainedToSize:maxSize
												 lineBreakMode:self.subTitle.lineBreakMode];
		return subTitleSize.height;
		
	}
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	[self.caption sizeToFit];
	CGFloat cellHeight = TABLE_CELL_TOP_MARGIN;
	cellHeight += CGRectGetHeight(self.caption.bounds);
	CGFloat subTitleHeight = [self subTitleHeight];
	if(subTitleHeight > 0.0)
	{
		cellHeight += TABLE_CELL_CHILD_SPACE;
		cellHeight += subTitleHeight;		
	}
	cellHeight += TABLE_CELL_BOTTOM_MARGIN;
	return cellHeight;
}

-(void) layoutSubviews {    
 
	[super layoutSubviews];    
   
	// Let the labels size themselves to accommodate their text    
	[caption sizeToFit];    
	[contentDescription sizeToFit];  
	
	
	// Position the labels at the top of the table cell
	[TableCellHelper topLeftAlignChild:caption withinParentFrame:self.contentView.bounds];
	[TableCellHelper topRightAlignChild:contentDescription withinParentFrame:self.contentView.bounds];
		
	CGFloat subTitleX = CGRectGetMinX(self.contentView.bounds) + TABLE_CELL_LEFT_MARGIN;
	CGFloat subTitleY = TABLE_CELL_TOP_MARGIN + CGRectGetHeight(self.caption.bounds)+TABLE_CELL_CHILD_SPACE;
	
	[self.subTitle setFrame: CGRectMake(subTitleX, subTitleY, 
				[self subTitleWidthWithMargin],
				[self subTitleHeight])];

}

- (void)dealloc
{
	[contentDescription release];
	[subTitle release];
	[caption release];
    [super dealloc];
}

@end
