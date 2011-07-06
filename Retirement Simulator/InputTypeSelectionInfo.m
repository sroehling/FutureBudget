//
//  InputTypeSelectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputTypeSelectionInfo.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"
#import "DataModelController.h"
#import "EventRepeatFrequency.h"
#import "FixedValue.h"
#import "FixedDate.h"
#import "NeverEndDate.h"
#import "SharedAppValues.h"
#import "MultiScenarioInputValue.h"


@implementation InputTypeSelectionInfo

@synthesize description;

-(Input*)createInput
{
    assert(0); // must be overridden
    return nil;
}

-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput
{
    // The following fields are not initialized upon creation, since the user
    // must provide a value (one can't be defaulted).
    //      newInput.name
    //      newInput.amount
    //      newInput.amountGrowthRate
	
    
    FixedValue *fixedGrowthRate = 
    (FixedValue*)[[DataModelController theDataModelController]insertObject:FIXED_VALUE_ENTITY_NAME];
    fixedGrowthRate.value = [NSNumber numberWithDouble:0.0];
    newInput.defaultFixedGrowthRate = fixedGrowthRate;

    FixedValue *fixedAmount = 
    (FixedValue*)[[DataModelController theDataModelController]insertObject:FIXED_VALUE_ENTITY_NAME];
    fixedAmount.value = [NSNumber numberWithDouble:0.0];
    newInput.defaultFixedAmount = fixedAmount;

    FixedDate *fixedStartDate = (FixedDate*)[[
                DataModelController theDataModelController] insertObject:FIXED_DATE_ENTITY_NAME];
    fixedStartDate.date = [NSDate date];
    newInput.fixedStartDate = fixedStartDate;
    
    FixedDate *fixedEndDate = (FixedDate*)[[
            DataModelController theDataModelController] insertObject:FIXED_DATE_ENTITY_NAME];
		
    fixedEndDate.date = [NSDate date];
    newInput.fixedEndDate = fixedEndDate;
	MultiScenarioInputValue *msEndDate = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msEndDate setDefaultValue:[DataModelController theDataModelController].sharedAppVals.sharedNeverEndDate];
	newInput.multiScenarioEndDate = msEndDate;
    
    NSArray *repeatFrequencies = [[DataModelController theDataModelController] fetchSortedObjectsWithEntityName:EVENT_REPEAT_FREQUENCY_ENTITY_NAME sortKey:@"period"];
    assert([repeatFrequencies count] >0);
	
	EventRepeatFrequency *repeatOnce = [DataModelController theDataModelController].sharedAppVals.repeatOnceFreq;
	assert(repeatOnce != nil);
	MultiScenarioInputValue *msRepeatFreq = 
		[[DataModelController theDataModelController] insertObject:MULTI_SCENARIO_INPUT_VALUE_ENTITY_NAME];
	[msRepeatFreq setDefaultValue:repeatOnce];
	newInput.multiScenarioEventRepeatFrequency = msRepeatFreq;
    
}


@end

@implementation ExpenseInputTypeSelectionInfo


-(Input*)createInput
{
    ExpenseInput *newInput  = (ExpenseInput*)[NSEntityDescription insertNewObjectForEntityForName:            @"ExpenseInput" 
         inManagedObjectContext:[[DataModelController theDataModelController] managedObjectContext]];

    newInput.inputType = @"Expense";    
    [self populateCashFlowInputProperties:newInput];
    
    [[DataModelController theDataModelController] saveContext];
    
    return newInput;
}

@end

@implementation IncomeInputTypeSelectionInfo

-(Input*)createInput
{
    IncomeInput *newInput  = (IncomeInput*)[NSEntityDescription insertNewObjectForEntityForName:            @"IncomeInput" 
        inManagedObjectContext:[[DataModelController theDataModelController] managedObjectContext]];

    newInput.inputType = @"Income";
    [self populateCashFlowInputProperties:newInput];
    
    [[DataModelController theDataModelController] saveContext];
    
    return newInput;
  
}

@end