//
//  StaticNameFieldCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StaticNameFieldCell.h"
#import "TableCellHelper.h"

NSString * const STATIC_NAME_FIELD_CELL_IDENTIFIER = @"StaticNameFieldCell";

@implementation StaticNameFieldCell

@synthesize staticName;

-(void)dealloc
{
	[super dealloc];
	[staticName release];
}


- (id) initWithFrame:(CGRect)frame
{
	self =[super initWithFrame: frame];
	if(self)
	{              
		
		self.staticName = [TableCellHelper createLabel];
		self.staticName.textAlignment = UITextAlignmentCenter;
     

		[self.contentView addSubview: self.staticName];    
				
		self.editingAccessoryType = UITableViewCellAccessoryNone;
		self.accessoryType = UITableViewCellAccessoryNone;		
		
	}    
	return self;
}


-(void) layoutSubviews {    
	
	[super layoutSubviews];    
	
	// Let the labels size themselves to accommodate their text    
	[self.staticName sizeToFit];
	[TableCellHelper sizeChildWidthToFillParent:self.staticName withinParentFrame:self.contentView.bounds];
	CGRect newRect = self.staticName.bounds;
	newRect.size.height += 2;
	[self.staticName setFrame:newRect];    
	
	// Position the labels at the top of the table cell 
	[TableCellHelper topLeftAlignChild:self.staticName withinParentFrame:self.contentView.bounds];
		
}

@end
