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

static CGFloat kLeftMargin = 10.0;
static CGFloat kRightMargin = 10.0;
static CGFloat kTopMargin = 5.0;

@implementation BoolFieldCell

@synthesize label;
@synthesize boolSwitch;
@synthesize boolFieldInfo;


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
				
		self.editingAccessoryType = UITableViewCellAccessoryNone;
		self.accessoryType = UITableViewCellAccessoryNone;
	}    
	return self;
}


-(void) layoutSubviews {    
	
	[super layoutSubviews];    
	
	// Let the labels size themselves to accommodate their text    
	[self.label sizeToFit];
	[self.boolSwitch sizeToFit];    
	 
	[TableCellHelper topLeftAlignChild:self.label withinParentFrame:self.contentView.bounds];  
	[TableCellHelper topRightAlignChild:self.boolSwitch withinParentFrame:self.contentView.bounds];
  
		
}

-(void)dealloc
{
    [super dealloc];
	[label release];
	[boolSwitch release];
	[boolFieldInfo release];
}

@end
