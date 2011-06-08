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
#import "EventRepeatFrequency.h"

#import "SectionInfo.h"
#import "FormInfo.h"
#import "FormPopulator.h"

@implementation DetailInputViewCreator

@synthesize input;

-(id) initWithInput:(Input*)theInput
{
    self = [super init];
    if(self)
    {
        assert(theInput!=nil);
        self.input = theInput;
    }
    return self;
}

-(id) init
{
    assert(0); // should not be called
}


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    [formPopulator release];
    formPopulator = [[FormPopulator alloc] init];
    
    [self.input acceptInputVisitor:self];
    
    return formPopulator.formInfo;

}


/*
- (UIViewController *)createAddViewForInput:(Input *)input
{
    [self populateFieldInfoForInput:input];
    
    UIViewController *addViewController = 
    [[[GenericFieldBasedTableAddViewController alloc] initWithFormInfo:formPopulator.formInfo andNewObject:input] autorelease];
    return addViewController;

}
 */

- (void) visitCashFlow:(CashFlowInput *)cashFlow
{
    SectionInfo *sectionInfo = [formPopulator nextSection];
    [sectionInfo addFieldEditInfo:[TextFieldEditInfo createForObject:cashFlow andKey:@"name" andLabel:@"Name"]];
    
    // Amount section
    
    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = @"Amount";
    [sectionInfo addFieldEditInfo:[NumberFieldEditInfo createForObject:cashFlow andKey:@"amount" andLabel:@"Amount"]];

    [sectionInfo addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForObject:cashFlow andKey:@"amountGrowthRate" andLabel:@"Inflation" 
         andEntityName:@"InflationRate" andDefaultFixedValKey:@"defaultFixedGrowthRate"]];

    // Occurences section

    sectionInfo = [formPopulator nextSection];
    sectionInfo.title = @"Occurences";
    [sectionInfo addFieldEditInfo:
     [DateFieldEditInfo createForObject:cashFlow andKey:@"transactionDate" andLabel:@"First"]];
    
    [sectionInfo addFieldEditInfo:[VariableDateFieldEditInfo createForObject:cashFlow andKey:@"startDate" andLabel:@"Start" andDefaultValueKey:@"fixedStartDate"]];


    RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = [RepeatFrequencyFieldEditInfo createForObject:cashFlow andKey:@"repeatFrequency" andLabel:@"Repeat"];
    [sectionInfo addFieldEditInfo:repeatFrequencyInfo];
    
    // Only display (and prompt for) and end date when/if the repeat frequency is set to something other
    // than "Once", such that an end date is needed. TBD - Should the end date in this case default to 
    // "Plan end date".
     if([repeatFrequencyInfo.fieldInfo fieldIsInitializedInParentObject])
    {
        EventRepeatFrequency *repeatFreq = (EventRepeatFrequency*)[repeatFrequencyInfo.fieldInfo getFieldValue];
        assert(repeatFreq != nil);
        if([repeatFreq  eventRepeatsMoreThanOnce])
        {
            [sectionInfo addFieldEditInfo:[VariableDateFieldEditInfo createForObject:cashFlow andKey:@"endDate" andLabel:@"End" andDefaultValueKey:@"fixedEndDate"]];           
        }
        
    }
    
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
