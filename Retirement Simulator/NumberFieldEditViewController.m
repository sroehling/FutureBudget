//
//  NumberFieldEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberFieldEditViewController.h"
#import "DataModelController.h"


@implementation NumberFieldEditViewController

@synthesize textField,numberFormatter;

- (void) commidFieldEdit
{
    // TODO - Need validation/filtering of the data in the field, before committing to
    // save. 
    NSNumber *theValue = [numberFormatter numberFromString:textField.text];
    if(theValue != nil)
    {
        [self.fieldInfo setFieldValue:theValue];       
    }
}

- (void) initFieldUI
{
    
    textField.text = [self.numberFormatter stringFromNumber:[fieldInfo getFieldValue]];;
    textField.placeholder = self.title;
    [textField becomeFirstResponder];
    
}


- (void)dealloc
{
    [super dealloc];
    [textField release];
    [numberFormatter release];
}



- (NSNumberFormatter *)numberFormatter
{
    if (numberFormatter == nil)
    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return numberFormatter;
}


@end
