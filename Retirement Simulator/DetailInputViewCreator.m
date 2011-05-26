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
#import "GenericFieldBasedTableAddViewController.h"

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

- (void) populateFieldInfoForInput:(Input *)input
{
    [self.detailFieldEditInfo removeAllObjects];
    
    [input acceptInputVisitor:self];
    assert([detailFieldEditInfo count] > 0); // Need at least one field definition to be valid

}

- (UIViewController *)createDetailViewForInput:(Input*)input
{
    [self populateFieldInfoForInput:input];
    
    UIViewController *detailViewController = 
        [[[GenericFieldBasedTableEditViewController alloc] initWithFieldEditInfo:detailFieldEditInfo] autorelease];
    return detailViewController;

}

- (UIViewController *)createAddViewForInput:(Input *)input
{
    [self populateFieldInfoForInput:input];
    
    UIViewController *addViewController = 
    [[[GenericFieldBasedTableAddViewController alloc] initWithFieldEditInfo:detailFieldEditInfo andNewObject:input] autorelease];
    return addViewController;

}

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{
    [detailFieldEditInfo addObject:
        [TextFieldEditInfo createForObject:cashFlow andKey:@"name" andLabel:@"Name"]];    
    [detailFieldEditInfo addObject:
        [NumberFieldEditInfo createForObject:cashFlow andKey:@"amount" andLabel:@"Amount"]];
 
    [detailFieldEditInfo addObject:
        [DateSensitiveValueFieldEditInfo 
         createForObject:cashFlow andKey:@"amountGrowthRate" andLabel:@"Amount Growth Rate" 
         andEntityName:@"InflationRate"]];

    [detailFieldEditInfo addObject:
     [DateFieldEditInfo createForObject:cashFlow andKey:@"transactionDate" andLabel:@"Date"]];

    [detailFieldEditInfo addObject:
     [RepeatFrequencyFieldEditInfo createForObject:cashFlow andKey:@"repeatFrequency" andLabel:@"Repeat"]];
        
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
