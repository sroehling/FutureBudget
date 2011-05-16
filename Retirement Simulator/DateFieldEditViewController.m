//
//  DateFieldEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateFieldEditViewController.h"
#import "DataModelController.h"

@implementation DateFieldEditViewController

@synthesize datePicker;


- (void) commidFieldEdit
{
    [fieldInfo setFieldValue:datePicker.date]; 
}

- (void) initFieldUI
{
    datePicker.hidden = NO;
    datePicker.date = [fieldInfo getFieldValue];

}


- (void)dealloc {
    [datePicker release];
	[super dealloc];
}




@end
