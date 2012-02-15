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

#define MAX_NAME_LENGTH 32

@implementation NameFieldCell

@synthesize textField;
@synthesize fieldInfo;
@synthesize disabled;


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
		
		self.disabled = FALSE;
		
	}    
	return self;
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range 
	replacementString:(NSString *)string 
{
    NSUInteger newLength = [theTextField.text length] + [string length] - range.length;
    return (newLength > MAX_NAME_LENGTH) ? NO : YES;
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
	
	if(!self.disabled)
	{
		[self.fieldInfo setFieldValue:self.textField.text];
	}
    
    // Done with editing - commit the value if it's changed

    [theTextField resignFirstResponder];

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)theTextField
{
	if(self.disabled)
	{
		return YES;
	}
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
	[textField release];
	[fieldInfo release];
	[super dealloc];
}


@end

