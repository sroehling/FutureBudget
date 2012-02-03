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
#import "NumberFieldValidator.h"
#import "FieldInfo.h"
#import "LocalizationHelper.h"

NSString * const NUMBER_FIELD_CELL_ENTITY_NAME = @"NumberFieldCell";

#define NUMBER_FIELD_MAX_WIDTH 120.0
#define NUMBER_FIELD_MIN_WIDTH 80.0

@implementation NumberFieldCell

@synthesize label, textField;
@synthesize fieldInfo;
@synthesize validator;
@synthesize numFormatter;
@synthesize disabled;

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
	
	// Constrain the width of the text field, so it doesn't take over too much 
	// of the cell.
	CGRect newFrame = self.textField.frame;
	newFrame.size.width = MIN(CGRectGetWidth(self.textField.bounds),NUMBER_FIELD_MAX_WIDTH);
	newFrame.size.width = MAX(newFrame.size.width,NUMBER_FIELD_MIN_WIDTH);
	[self.textField setFrame:newFrame];
	
	
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

- (NSString*)formattedNumber
{
	NSNumber *displayVal = [[NumberHelper theHelper] displayValFromStoredVal:[self.fieldInfo getFieldValue] andFormatter:self.numFormatter];
    return [self.numFormatter stringFromNumber:displayVal];
 
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
	if(!self.disabled)
	{
		assert(self.fieldInfo != nil);
		// Done with editing - commit the value if it's changed
		
		
		NSNumber *theValue = [[NumberHelper theHelper].decimalFormatter 
							  numberFromString:theTextField.text];
		if(theValue != nil)
		{
			[self.fieldInfo setFieldValue:theValue];       
		}
		
		// Restore the text in the field to the format as specified
		// by the FieldEditInfo
		self.textField.text = [self formattedNumber];
		
		// Done with editing - commit the value if it's changed
		
		[theTextField resignFirstResponder];
	}

}

- (void)textFieldDidBeginEditing:(UITextField *)theTextField
{
	// editableNumberFormatter is the same as decimalNumberFormatter in NumberHelper, except
	// that the grouping separator is set to the empty string. Having comma separator appear
	// while editing numbers sometimes caused difficulty with editing.
	NSNumberFormatter *editableNumberFormatter = [[[NSNumberFormatter alloc]init] autorelease];
	[editableNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[editableNumberFormatter setMinimumFractionDigits:0];
	[editableNumberFormatter setMaximumFractionDigits:3];
	[editableNumberFormatter setGroupingSeparator:@""];
	
	
	if([self.fieldInfo fieldIsInitializedInParentObject])
	{
		NSNumber *value = (NSNumber*)[self.fieldInfo getFieldValue];
		NSString *formattedValue =  [editableNumberFormatter stringFromNumber:value];
		assert(formattedValue != nil);
		// For editing purposes, update the cell to have a plain decimal number
		self.textField.text = formattedValue;
	}
	else
	{
		self.textField.text = @"";
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)theTextField
{
	if(self.disabled)
	{
		return TRUE;
	}
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
				NSString *errorMsg = LOCALIZED_STR(@"NUMBER_VALIDATION_VALIDATION_NOT_A_NUMBER_MSG");
				if(self.validator != nil)
				{
					errorMsg = LOCALIZED_STR(self.validator.validationFailedMsg);
				}
				UIAlertView *av = [[[UIAlertView alloc] initWithTitle:LOCALIZED_STR(@"NUMBER_VALIDATION_VALIDATION_ERROR_POPUP_TITLE")
					message:errorMsg delegate:self 
					cancelButtonTitle:LOCALIZED_STR(@"NUMBER_VALIDATION_POPUP_CANCEL_BUTTON_TITLE") 
					otherButtonTitles:nil] autorelease];
				[av show];
				return NO;			
			}
			
			if(self.validator != nil)
			{
				if([self.validator validateNumber:theNumber])
				{
					return YES;
				}
				else
				{
					assert(self.validator.validationFailedMsg != nil);
					UIAlertView *av = [[[UIAlertView alloc] initWithTitle:LOCALIZED_STR(@"NUMBER_VALIDATION_VALIDATION_ERROR_POPUP_TITLE")
					message:self.validator.validationFailedMsg delegate:self 
					cancelButtonTitle:LOCALIZED_STR(@"NUMBER_VALIDATION_POPUP_CANCEL_BUTTON_TITLE") 
					otherButtonTitles:nil] autorelease];
					[av show];
					return NO;			
				}
			}
			
		}	
	}
	return YES;
}


- (void)dealloc {
	[label release];
	[textField release];
	
    [fieldInfo release];
	[validator release];
	[numFormatter release];

	[super dealloc];
}


@end
