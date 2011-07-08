//
//  DateFieldEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateFieldEditViewController.h"
#import "DataModelController.h"
#import "DateHelper.h"
#import "FieldInfo.h"

@implementation DateFieldEditViewController

@synthesize datePicker;


- (void) commidFieldEdit
{
    [fieldInfo setFieldValue:datePicker.date]; 
}

- (void) initFieldUI
{
    datePicker.hidden = NO;
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    if([fieldInfo fieldIsInitializedInParentObject])
    {
        datePicker.date = [fieldInfo getFieldValue];
    }
    else
    {
        datePicker.date = [DateHelper today];
    }
}


- (void)dealloc {
    [datePicker release];
	[super dealloc];
}


@end
