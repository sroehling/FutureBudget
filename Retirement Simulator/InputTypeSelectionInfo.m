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


@implementation InputTypeSelectionInfo

@synthesize description;

-(Input*)createInput
{
    assert(0); // must be overridden
    return nil;
}

@end

@implementation ExpenseInputTypeSelectionInfo

-(Input*)createInput
{
    ExpenseInput *newInput  = (ExpenseInput*)[NSEntityDescription insertNewObjectForEntityForName:            @"ExpenseInput" 
         inManagedObjectContext:[[DataModelController theDataModelController] managedObjectContext]];
    // The following fields are not initialized upon creation, since the user
    // must provide a value (one can't be defaulted).
    //      newInput.name
    //      newInput.amount
    newInput.inputType = @"Expense";
    newInput.transactionDate = [NSDate date];

    FixedValue *fixedGrowthRate = (FixedValue*)[NSEntityDescription insertNewObjectForEntityForName:            @"FixedValue" inManagedObjectContext:
        [[DataModelController theDataModelController] managedObjectContext]];
    fixedGrowthRate.value = [NSNumber numberWithDouble:0.0];
    newInput.amountGrowthRate = fixedGrowthRate; 
    
    NSArray *repeatFrequencies = [[DataModelController theDataModelController] fetchSortedObjectsWithEntityName:@"EventRepeatFrequency" sortKey:@"period"];
    assert([repeatFrequencies count] >0);
    
    newInput.repeatFrequency = (EventRepeatFrequency *)[repeatFrequencies objectAtIndex:0];
    assert(newInput.repeatFrequency != nil);

    NSLog(@"New Input with Repeat Frequency: %@",newInput.repeatFrequency.description);
    
    [[DataModelController theDataModelController] saveContext];
    
    return newInput;
}

@end

@implementation IncomeInputTypeSelectionInfo

-(Input*)createInput
{
    IncomeInput *newInput  = (IncomeInput*)[NSEntityDescription insertNewObjectForEntityForName:            @"IncomeInput" 
        inManagedObjectContext:[[DataModelController theDataModelController] managedObjectContext]];
    // The following fields are not initialized upon creation, since the user
    // must provide a value (one can't be defaulted).
    //      newInput.name
    //      newInput.amount
    newInput.inputType = @"Income";
    newInput.transactionDate = [NSDate date];
    
    FixedValue *fixedGrowthRate = (FixedValue*)[NSEntityDescription insertNewObjectForEntityForName:            @"FixedValue" inManagedObjectContext:
            [[DataModelController theDataModelController] managedObjectContext]];
    fixedGrowthRate.value = [NSNumber numberWithDouble:0.0];
    newInput.amountGrowthRate = fixedGrowthRate; 
    
    NSArray *repeatFrequencies = [[DataModelController theDataModelController] fetchSortedObjectsWithEntityName:@"EventRepeatFrequency" sortKey:@"period"];
    assert([repeatFrequencies count] >0);
    
    newInput.repeatFrequency = (EventRepeatFrequency *)[repeatFrequencies objectAtIndex:0];
    assert(newInput.repeatFrequency != nil);
    NSLog(@"New Input with Repeat Frequency: %@",newInput.repeatFrequency.description);
    
    [[DataModelController theDataModelController] saveContext];
    
    return newInput;
  
}

@end