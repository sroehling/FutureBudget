//
//  TextFieldEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextFieldEditViewController.h"
#import "DataModelController.h"


@implementation TextFieldEditViewController

@synthesize textField;


- (void) commidFieldEdit
{
     [self.fieldInfo setFieldValue:textField.text];
}

- (void) initFieldUI
{
    textField.text = [self.fieldInfo getFieldValue];
    textField.placeholder = self.title;
    [textField becomeFirstResponder];    
}


- (void)dealloc {
    [textField release];
	[super dealloc];
}


@end
