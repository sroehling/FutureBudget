//
//  TextFieldCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextFieldCell.h"
#import "TextFieldEditInfo.h"
#import "NumberHelper.h"
#import "TableCellHelper.h"


NSString * const TEXT_FIELD_CELL_ENTITY_NAME = @"TextFieldCell";

@implementation TextFieldCell


@synthesize label, textField;
@synthesize fieldEditInfo;


- (id) initWithFrame:(CGRect)frame
{
	self =[super initWithFrame: frame];
	if(self)
	{        
		self.label =[TableCellHelper createLabel];       
		[self.contentView addSubview: self.label];        
		
		self.textField = [TableCellHelper createTextField]; 
		textField.delegate = self;    

		[self.contentView addSubview: self.textField];    
				
		self.editingAccessoryType = UITableViewCellAccessoryNone;
		self.accessoryType = UITableViewCellAccessoryNone;		
		
	}    
	return self;
}


-(void) layoutSubviews {    
	
	[super layoutSubviews];    
	
	// Let the labels size themselves to accommodate their text    
	[self.label sizeToFit];
	[self.textField sizeToFit];    
	
	// Position the labels at the top of the table cell 
	[TableCellHelper topLeftAlignChild:self.label withinParentFrame:self.contentView.bounds];
	[TableCellHelper topRightAlignChild:self.textField withinParentFrame:self.contentView.bounds];
		
}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
	[super setEditing:editing animated:animated];
	[TableCellHelper enableTextFieldEditing:self.textField andEditing:editing];
}

// UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    assert(self.fieldEditInfo != nil);
    
    [self.fieldEditInfo.fieldInfo setFieldValue:self.textField.text];
    // Done with editing - commit the value if it's changed

    [theTextField resignFirstResponder];

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)theTextField
{
	if(theTextField == self.textField)
	{
		if([self.textField.text length] == 0 )
		{
			return NO;
		}
	}
	return YES;
}



- (void)dealloc {
	[label release];
	[textField release];
    [fieldEditInfo release];
	[super dealloc];
}

@end
