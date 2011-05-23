//
//  TextFieldEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextFieldEditViewController.h"
#import "DataModelController.h"
#import "StringValidation.h"


@implementation TextFieldEditViewController

@synthesize textField;

+(TextFieldEditViewController*)createControllerForObject:
    (NSManagedObject*)managedObject 
    andFieldKey:(NSString*)key andFieldLabel:(NSString*)label;
{
    assert(managedObject != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    
    ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
                                          initWithManagedObject:managedObject 
                                          andFieldKey:key andFieldLabel:label] autorelease];
    
    
    TextFieldEditViewController *textController = 
    [[[TextFieldEditViewController alloc] initWithNibName:@"TextFieldEditViewController" 
                                               andFieldInfo:fieldInfo] autorelease];
    return textController;
}



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
