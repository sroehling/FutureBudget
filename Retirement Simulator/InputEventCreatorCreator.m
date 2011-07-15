//
//  InputEventCreatorCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputEventCreatorCreator.h"
#import "CashFlowSimEventCreator.h"
#import "DataModelController.h"
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
    CashFlowSimEventCreator *theCreator = 
		[[CashFlowSimEventCreator alloc]initWithCashFlow:income];
    self.currSimEventCreator = theCreator;
    [theCreator release];
}

- (void)visitExpense:(ExpenseInput*)expense
{
    CashFlowSimEventCreator *theCreator = 
        [[CashFlowSimEventCreator alloc]initWithCashFlow:expense];
    self.currSimEventCreator = theCreator;
    [theCreator release];
}

- (void)visitSavingsAccount:(SavingsAccount *)savingsAcct
{
	assert(0); // not implemented yet
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
