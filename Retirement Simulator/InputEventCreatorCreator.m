//
//  InputEventCreatorCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputEventCreatorCreator.h"
#import "ExpenseInputSimEventCreator.h"
#import "DataModelController.h"
#import "SimEngine.h"
#import "Input.h"

@implementation InputEventCreatorCreator 

//@synthesize currentSimEventCreator=currentSimEventCreator_;
@synthesize currSimEventCreator;

- (void)reset
{
    self.currSimEventCreator = nil;
}

- (void)visitExpense:(ExpenseInput*)expense
{
    ExpenseInputSimEventCreator *theCreator = 
        [[ExpenseInputSimEventCreator alloc]initWithExpense:expense];
    self.currSimEventCreator = theCreator;
    [theCreator release];
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
