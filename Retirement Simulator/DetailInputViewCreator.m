//
//  DetailInputViewCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailInputViewCreator.h"
#import "ExpenseInput.h"

#import "ManagedObjectFieldInfo.h"
#import "TextFieldEditInfo.h"
#import "NumberFieldEditInfo.h"
#import "DateFieldEditInfo.h"
#import "RepeatFrequencyFieldEditInfo.h"
#import "GenericFieldBasedTableEditViewController.h"

@implementation DetailInputViewCreator

@synthesize detailViewController;

- (void)visitExpense:(ExpenseInput*)expense
{
    NSMutableArray *detailFieldEditInfo = [[NSMutableArray alloc] init ];
    
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
                                          initWithManagedObject:expense andFieldKey:@"name" andFieldLabel:@"Input Name"];
    ManagedObjectFieldEditInfo *fieldEditInfo = [[TextFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [detailFieldEditInfo addObject:fieldEditInfo];
    [fieldEditInfo release];
    [fieldInfo release];
    
    fieldInfo = [[ManagedObjectFieldInfo alloc] 
                  initWithManagedObject:expense andFieldKey:@"amount" andFieldLabel:@"Amount"];
    fieldEditInfo = [[NumberFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [detailFieldEditInfo addObject:fieldEditInfo];
    [fieldEditInfo release];
    [fieldInfo release];
    
    fieldInfo = [[ManagedObjectFieldInfo alloc] 
                  initWithManagedObject:expense andFieldKey:@"transactionDate" andFieldLabel:@"Date"];
    fieldEditInfo = [[DateFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [detailFieldEditInfo addObject:fieldEditInfo];
    [fieldEditInfo release];
    [fieldInfo release];
    
    fieldInfo = [[ManagedObjectFieldInfo alloc] 
                  initWithManagedObject:expense andFieldKey:@"repeatFrequency" andFieldLabel:@"Repeat"];
    fieldEditInfo = [[RepeatFrequencyFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [detailFieldEditInfo addObject:fieldEditInfo];
    [fieldEditInfo release];
    [fieldInfo release];
    
    detailViewController = 
        [[GenericFieldBasedTableEditViewController alloc] initWithFieldEditInfo:detailFieldEditInfo];
    [detailFieldEditInfo release];
}

- (void)dealloc
{
    [detailViewController release];
    [super dealloc];
}


@end
