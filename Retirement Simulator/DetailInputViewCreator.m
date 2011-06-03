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
#import "VariableDateFieldEditInfo.h"
#import "RepeatFrequencyFieldEditInfo.h"
#import "DateSensitiveValueFieldEditInfo.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "GenericFieldBasedTableAddViewController.h"

#import "SectionInfo.h"
#import "FormInfo.h"
#import "FormPopulator.h"

@implementation DetailInputViewCreator



- (void) populateFieldInfoForInput:(Input *)input
{
    [formPopulator release];
    formPopulator = [[FormPopulator alloc] init];
    
    [input acceptInputVisitor:self];

}

- (UIViewController *)createDetailViewForInput:(Input*)input
{
    [self populateFieldInfoForInput:input];
    
    
    UIViewController *detailViewController = 
        [[[GenericFieldBasedTableEditViewController alloc] initWithFormInfo:formPopulator.formInfo] autorelease];
    return detailViewController;

}

- (UIViewController *)createAddViewForInput:(Input *)input
{
    [self populateFieldInfoForInput:input];
    
    UIViewController *addViewController = 
    [[[GenericFieldBasedTableAddViewController alloc] initWithFormInfo:formPopulator.formInfo andNewObject:input] autorelease];
    return addViewController;

}

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{
    SectionInfo *sectionInfo = [formPopulator nextSection];
    [sectionInfo addFieldEditInfo:[TextFieldEditInfo createForObject:cashFlow andKey:@"name" andLabel:@"Name"]];
    
    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = @"Amount";
    [sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:cashFlow andKey:@"amount" andLabel:@"Amount"]];
    [sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForObject:cashFlow andKey:@"amountGrowthRate" andLabel:@"Inflation" 
         andEntityName:@"InflationRate"]];


    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = @"Occurences";
    [sectionInfo addFieldEditInfo:
     [DateFieldEditInfo createForObject:cashFlow andKey:@"transactionDate" andLabel:@"First"]];
    [sectionInfo addFieldEditInfo:[VariableDateFieldEditInfo createForObject:cashFlow andKey:@"startDate" andLabel:@"Start"]];
    [sectionInfo addFieldEditInfo:
     [RepeatFrequencyFieldEditInfo createForObject:cashFlow andKey:@"repeatFrequency" andLabel:@"Repeat"]];
        
}

- (void)visitExpense:(ExpenseInput*)expense
{    
    formPopulator.formInfo.title = @"Expense";
}

- (void)visitIncome:(IncomeInput*)input
{
    formPopulator.formInfo.title = @"Income";
}


- (void)dealloc
{
    [formPopulator release];
    [super dealloc];
}


@end
