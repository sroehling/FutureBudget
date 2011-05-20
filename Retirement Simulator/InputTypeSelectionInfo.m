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

-(void)createInput
{
    assert(0); // must be overridden
}

@end

@implementation ExpenseInputTypeSelectionInfo

-(void)createInput
{
    ExpenseInput *newInput  = (ExpenseInput*)[NSEntityDescription insertNewObjectForEntityForName:            @"ExpenseInput" 
         inManagedObjectContext:[[DataModelController theDataModelController] managedObjectContext]];
    newInput.name = @"New Expense";
    newInput.inputType = @"Expense";
    newInput.amount = [NSNumber numberWithInt:2000];
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
}

@end

@implementation IncomeInputTypeSelectionInfo

-(void)createInput
{
    IncomeInput *newInput  = (IncomeInput*)[NSEntityDescription insertNewObjectForEntityForName:            @"IncomeInput" 
        inManagedObjectContext:[[DataModelController theDataModelController] managedObjectContext]];
    newInput.name = @"New Income";
    newInput.inputType = @"Income";
    newInput.amount = [NSNumber numberWithInt:2000];
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
  
}

@end