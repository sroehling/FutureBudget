//
//  DetailInputViewCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailInputViewCreator.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"

#import "ManagedObjectFieldInfo.h"
#import "TextFieldEditInfo.h"
#import "NumberFieldEditInfo.h"
#import "DateFieldEditInfo.h"
#import "RepeatFrequencyFieldEditInfo.h"
#import "DateSensitiveValueFieldEditInfo.h"
#import "GenericFieldBasedTableEditViewController.h"

@implementation DetailInputViewCreator

@synthesize detailFieldEditInfo;

- (id) init
{
    self = [super init];
    if(self)
    {
        self.detailFieldEditInfo = [[[NSMutableArray alloc] init ] autorelease];
    }
    return self;
}

- (UIViewController *)createDetailViewForInput:(Input*)input
{
    [self.detailFieldEditInfo removeAllObjects];
    
    [input acceptInputVisitor:self];
    assert([detailFieldEditInfo count] > 0); // Need at least one field definition to be valid
    
    UIViewController *detailViewController = 
        [[[GenericFieldBasedTableEditViewController alloc] initWithFieldEditInfo:detailFieldEditInfo] autorelease];
    return detailViewController;

}

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
                                         initWithManagedObject:cashFlow andFieldKey:@"name" andFieldLabel:@"Input Name"];
    ManagedObjectFieldEditInfo *fieldEditInfo = [[TextFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [detailFieldEditInfo addObject:fieldEditInfo];
    [fieldEditInfo release];
    [fieldInfo release];
    
    fieldInfo = [[ManagedObjectFieldInfo alloc] 
                 initWithManagedObject:cashFlow andFieldKey:@"amount" andFieldLabel:@"Amount"];
    fieldEditInfo = [[NumberFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [detailFieldEditInfo addObject:fieldEditInfo];
    [fieldEditInfo release];
    [fieldInfo release];
    
    fieldInfo = [[ManagedObjectFieldInfo alloc] 
                 initWithManagedObject:cashFlow andFieldKey:@"amountGrowthRate" andFieldLabel:@"Amount Growth Rate"];
    DateSensitiveValueFieldEditInfo *dsFieldEditInfo = 
        [[[DateSensitiveValueFieldEditInfo alloc] initWithFieldInfo:fieldInfo] autorelease];
    dsFieldEditInfo.variableValueEntityName = @"InflationRate";
    [detailFieldEditInfo addObject:dsFieldEditInfo];
    [fieldInfo release];

    
    fieldInfo = [[ManagedObjectFieldInfo alloc] 
                 initWithManagedObject:cashFlow andFieldKey:@"transactionDate" andFieldLabel:@"Date"];
    fieldEditInfo = [[DateFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [detailFieldEditInfo addObject:fieldEditInfo];
    [fieldEditInfo release];
    [fieldInfo release];
    
    fieldInfo = [[ManagedObjectFieldInfo alloc] 
                 initWithManagedObject:cashFlow andFieldKey:@"repeatFrequency" andFieldLabel:@"Repeat"];
    fieldEditInfo = [[RepeatFrequencyFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [detailFieldEditInfo addObject:fieldEditInfo];
    [fieldEditInfo release];
    [fieldInfo release];
}

- (void)visitExpense:(ExpenseInput*)expense
{    
}

- (void)visitIncome:(IncomeInput*)input
{
}


- (void)dealloc
{
    [detailFieldEditInfo release];
    [super dealloc];
}


@end
