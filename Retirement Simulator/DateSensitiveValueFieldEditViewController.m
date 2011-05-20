//
//  DateSensitiveValueFieldEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueFieldEditViewController.h"
#import "DataModelController.h"

@implementation DateSensitiveValueFieldEditViewController

@synthesize currentValue,variableValues,variableValueEntityName;

- (void) commidFieldEdit
{
    assert(currentValue != nil);
    [fieldInfo setFieldValue:currentValue]; 
}

- (void) initFieldUI
{
    assert(variableValueEntityName != nil);
    assert([variableValueEntityName length] > 0);
    self.variableValues = [[DataModelController theDataModelController]
            fetchSortedObjectsWithEntityName:self.variableValueEntityName sortKey:@"startDate"]; 
    // TODO - When variable values support milestone dates
    // we'll have to sort by value, then resort using the looked up
    // date value of the milestone date.
 
     self.currentValue = [self.fieldInfo getFieldValue];
}



- (void)dealloc
{
    [super dealloc];
    [variableValues release];
    [variableValues release];
    
}

@end
