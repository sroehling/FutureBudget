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


@implementation TextFieldCell


@synthesize label, textField;
@synthesize fieldEditInfo;

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


-(IBAction)editingTextEnded:(id)sender
{    
    assert(self.fieldEditInfo != nil);
    

    [self.fieldEditInfo.fieldInfo setFieldValue:self.textField.text];
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
