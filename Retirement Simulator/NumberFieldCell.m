//
//  NumberFieldCell.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberFieldCell.h"
#import "NumberFieldEditInfo.h"
#import "NumberHelper.h"
#import "TableCellHelper.h"

NSString * const NUMBER_FIELD_CELL_ENTITY_NAME = @"NumberFieldCell";

@implementation NumberFieldCell

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


// TextFieldDelegate methods

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    assert(self.fieldEditInfo != nil);
    // Done with editing - commit the value if it's changed
    
    NSNumber *theValue = [[NumberHelper theHelper].decimalFormatter 
                          numberFromString:theTextField.text];
    if(theValue != nil)
    {
        [self.fieldEditInfo.fieldInfo setFieldValue:theValue];       
    }
    
    // Restore the text in the field to the format as specified
    // by the FieldEditInfo
    self.textField.text = [self.fieldEditInfo detailTextLabel];
    
    // Done with editing - commit the value if it's changed
    
    [theTextField resignFirstResponder];

}

- (void)textFieldDidBeginEditing:(UITextField *)theTextField
{
    // For editing purposes, update the cell to have a plain decimal number
    NSNumber *value = (NSNumber*)[self.fieldEditInfo.fieldInfo getFieldValue];
    self.textField.text = 
        [[NumberHelper theHelper].decimalFormatter stringFromNumber:value];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)theTextField
{
	if(theTextField == self.textField)
	{
		if([self.textField.text length] == 0 )
		{
			return NO;
		}
		else
		{
			NSNumber *theNumber = 
				[[NumberHelper theHelper].decimalFormatter numberFromString:theTextField.text];
			if(theNumber ==  nil)
			{
				UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Entry Error"
					message:@"Enter a number"
					delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[av show];
				return NO;			
			}
			
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
