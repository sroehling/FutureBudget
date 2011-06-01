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

@implementation NumberFieldCell

@synthesize label, textField;
@synthesize fieldEditInfo;

// Note a connection is made in the XIB file
// to invoke this for the "Did End on Exit" event
-(IBAction)textFieldDismissKeyboard:(id)sender
{
    [sender resignFirstResponder];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
	[super setEditing:editing animated:animated];
	
    self.textField.enabled = editing;
    if(editing)
    {
        self.textField.borderStyle = UITextBorderStyleBezel;
    }
    else
    {
        self.textField.borderStyle = UITextBorderStyleNone;
    }
    
}

-(IBAction)editingTextStarted:(id)sender
{
    // For editing purposes, update the cell to have a plain decimal number
    NSNumber *value = (NSNumber*)[self.fieldEditInfo.fieldInfo getFieldValue];
    self.textField.text = 
        [[NumberHelper theHelper].decimalFormatter stringFromNumber:value];
}



-(IBAction)editingTextEnded:(id)sender
{    
    assert(self.fieldEditInfo != nil);
    // Done with editing - commit the value if it's changed
    
    NSNumber *theValue = [[NumberHelper theHelper].numberFormatter 
                          numberFromString:textField.text];
    if(theValue != nil)
    {
        [self.fieldEditInfo.fieldInfo setFieldValue:theValue];       
    }
    
    // Restore the text in the field to the format as specified
    // by the FieldEditInfo
    self.textField.text = [self.fieldEditInfo detailTextLabel];
    
    // Done with editing - commit the value if it's changed
    
    [sender resignFirstResponder];
}

- (void)dealloc {
	[label release];
	[textField release];
    [fieldEditInfo release];
	[super dealloc];
}

@end
