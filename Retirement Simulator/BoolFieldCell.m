//
//  BoolFieldCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoolFieldCell.h"
#import "FieldInfo.h"
#import "TableCellHelper.h"

NSString * const BOOL_FIELD_CELL_ENTITY_NAME = @"BoolFieldCell";

@implementation BoolFieldCell

@synthesize label;
@synthesize boolSwitch;
@synthesize boolFieldInfo;
@synthesize valueSubtitle;


-(IBAction)boolSwitchToggled:(id)sender
{
	NSLog(@"Bool switch toggled to %i",self.boolSwitch.on);
	[self.boolFieldInfo setFieldValue:[NSNumber numberWithBool:self.boolSwitch.on]];
}

- (id) initWithFrame:(CGRect)frame
{
	self =[super initWithFrame: frame];
	if(self)
	{        
		self.label = [TableCellHelper createLabel];
		[self.contentView addSubview: self.label];        
		
		self.boolSwitch =[TableCellHelper createSwitch];
		[self.boolSwitch addTarget:self action:@selector(boolSwitchToggled:) forControlEvents:UIControlEventValueChanged];
		[self.contentView addSubview: self.boolSwitch];
		
		self.valueSubtitle =[TableCellHelper createSubtitleLabel];
		[self.contentView addSubview: self.valueSubtitle];    
	    
		self.editingAccessoryType = UITableViewCellAccessoryNone;
		self.accessoryType = UITableViewCellAccessoryNone;
	}    
	return self;
}


- (CGFloat)cellHeight
{
	[label sizeToFit];    
	[boolSwitch sizeToFit];  
	[valueSubtitle sizeToFit];

	CGFloat cellHeight = TABLE_CELL_TOP_MARGIN;
	
	cellHeight += MAX(CGRectGetHeight(self.label.bounds),
					  CGRectGetHeight(self.boolSwitch.bounds));
	if([valueSubtitle.text length] > 0)
	{
		cellHeight += TABLE_CELL_CHILD_SPACE;
		cellHeight += CGRectGetHeight(self.valueSubtitle.bounds);
	}		
	cellHeight += TABLE_CELL_BOTTOM_MARGIN;
	
	return cellHeight;
}


-(void) layoutSubviews {    
	
	[super layoutSubviews];    
	
	// Let the labels size themselves to accommodate their text    
	[self.label sizeToFit];
	[self.boolSwitch sizeToFit];    
	 
	[valueSubtitle sizeToFit];  


	[TableCellHelper topLeftAlignChild:self.label withinParentFrame:self.contentView.bounds];  
	[TableCellHelper topRightAlignChild:self.boolSwitch withinParentFrame:self.contentView.bounds];
  
  	CGRect newFrame = valueSubtitle.frame;
	newFrame.origin.x =CGRectGetMinX(self.contentView.bounds)+TABLE_CELL_LEFT_MARGIN;
	CGFloat startY = MAX(CGRectGetMaxY(self.label.frame),CGRectGetMaxY(self.boolSwitch.frame));
	newFrame.origin.y = startY + TABLE_CELL_CHILD_SPACE; 
	
	[valueSubtitle setFrame:newFrame];   

		
}

-(void)dealloc
{
	[label release];
	[boolSwitch release];
	[boolFieldInfo release];
	[valueSubtitle release];
    [super dealloc];
}

@end
