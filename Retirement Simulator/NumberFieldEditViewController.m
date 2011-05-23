//
//  NumberFieldEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberFieldEditViewController.h"
#import "DataModelController.h"
#import "StringValidation.h"


@implementation NumberFieldEditViewController

@synthesize textField,numberFormatter;

+(NumberFieldEditViewController*)createControllerForObject:
    (NSManagedObject*)managedObject 
    andFieldKey:(NSString*)key andFieldLabel:(NSString*)label;
{
    assert(managedObject != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);

    ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
          initWithManagedObject:managedObject 
          andFieldKey:key andFieldLabel:label] autorelease];
    
    
    NumberFieldEditViewController *numberController = 
    [[[NumberFieldEditViewController alloc] initWithNibName:@"NumberFieldEditViewController" 
                                               andFieldInfo:fieldInfo] autorelease];
    return numberController;

}

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
