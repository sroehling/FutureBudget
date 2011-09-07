//
//  BoolFieldCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoolFieldCell.h"
#import "FieldInfo.h"

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
		self.label =[[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
		self.label.backgroundColor = [UIColor clearColor];
        self.label.opaque = NO;
        self.label.textColor = [UIColor blackColor];
		self.label.textAlignment = UITextAlignmentLeft;
        self.label.highlightedTextColor = [UIColor whiteColor];
        self.label.font = [UIFont boldSystemFontOfSize:14];       
		
		[self.contentView addSubview: self.label];        
		
		self.boolSwitch =[[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];        
		self.boolSwitch.backgroundColor = [UIColor clearColor];
        self.boolSwitch.opaque = NO;
		
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
	
	// Position the labels at the top of the table cell    
	CGRect newFrame = self.label.frame;    
	newFrame.origin.x =CGRectGetMinX(self.contentView.bounds)+kLeftMargin;
	newFrame.origin.y =CGRectGetMinY(self.contentView.bounds)+kTopMargin;
	[self.label setFrame: newFrame];    
	
  
	newFrame = self.boolSwitch.frame; 
	newFrame.origin.x = CGRectGetMaxX(self.contentView.bounds)-kRightMargin-
		CGRectGetWidth(boolSwitch.frame);  
	newFrame.origin.y =CGRectGetMinY(self.contentView.bounds)+kTopMargin;    
	[self.boolSwitch setFrame: newFrame];
		
}

-(void)dealloc
{
    [super dealloc];
	[label release];
	[boolSwitch release];
	[boolFieldInfo release];
}

@end
