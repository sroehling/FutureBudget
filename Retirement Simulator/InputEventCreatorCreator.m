//
//  InputEventCreatorCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputEventCreatorCreator.h"
#import "CashFlowSimEventCreator.h"
#import "IncomeSimEventCreator.h"
#import "ExpenseSimEventCreator.h"
#import "DataModelController.h"
#import "SavingsContributionSimEventCreator.h"
#import "SimEngine.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"
#import "Input.h"

@implementation InputEventCreatorCreator 

@synthesize currSimEventCreator;

- (void)reset
{
    self.currSimEventCreator = nil;
}

- (void)visitCashFlow:(CashFlowInput *)cashFlow
{
    
}

- (void) visitIncome:(IncomeInput *)income
{
	// TODO - Need to support a separate "IncomeEventCreator"
    IncomeSimEventCreator *theCreator = 
		[[IncomeSimEventCreator alloc]initWithIncome:income];
    self.currSimEventCreator = theCreator;
    [theCreator release];
}

- (void)visitExpense:(ExpenseInput*)expense
{
    ExpenseSimEventCreator *theCreator = 
        [[ExpenseSimEventCreator alloc]initWithExpense:expense];
    self.currSimEventCreator = theCreator;
    [theCreator release];
}

- (void)visitAccount:(Account *)account
{
   // no-op: implementation in sub-classes
}

- (void)visitSavingsAccount:(SavingsAccount *)savingsAcct
{
	SavingsContributionSimEventCreator *theCreator = 
        [[[SavingsContributionSimEventCreator alloc]initWithSavingsAcct:savingsAcct] autorelease];
    self.currSimEventCreator = theCreator;
}

-(void)populateSimEngine:(SimEngine*)simEngine
{
    DataModelController *theController = [DataModelController theDataModelController];
    NSSet *inputs = [theController fetchObjectsForEntityName:@"Input"];
    
    for(Input *input in inputs)
    {
        [input acceptInputVisitor:self];
        
        id<SimEventCreator> createdEventCreator = self.currSimEventCreator;

        assert(createdEventCreator != nil);
        [simEngine.eventCreators addObject:createdEventCreator];     
        [self reset];
    
    }
 
}

-(void)dealloc
{
    [super dealloc];
    [currSimEventCreator release];
}

@end
