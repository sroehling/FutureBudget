//
//  NameFieldCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NameFieldCell.h"
#import "TableCellHelper.h"

NSString * const NAME_FIELD_CELL_IDENTIFIER = @"NameFieldCell";

@implementation NameFieldCell

@synthesize textField;
@synthesize fieldInfo;


- (id) initWithFrame:(CGRect)frame
{
	self =[super initWithFrame: frame];
	if(self)
	{              
		
		self.textField = [TableCellHelper createTitleTextField]; 
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
	[self.textField sizeToFit];
	[TableCellHelper sizeChildWidthToFillParent:self.textField withinParentFrame:self.contentView.bounds];
	CGRect newRect = self.textField.bounds;
	newRect.size.height += 2;
	[self.textField setFrame:newRect];    
	
	// Position the labels at the top of the table cell 
	[TableCellHelper topLeftAlignChild:self.textField withinParentFrame:self.contentView.bounds];
		
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
    assert(self.fieldInfo != nil);
    
    [self.fieldInfo setFieldValue:self.textField.text];
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

-(void)dealloc
{
	[super dealloc];
	[textField release];
	[fieldInfo release];
}


@end

