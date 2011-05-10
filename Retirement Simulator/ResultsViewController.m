//
//  ResultsViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsViewController.h"
#import "DataModelController.h"
#import "OneTimeExpenseInput.h"
#import "ExpenseInputSimEventCreator.h"
#import "SimEngine.h"

@implementation ResultsViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Simulator interface

- (void) runSimulatorForResults
{
    DataModelController *theController = [DataModelController theDataModelController];
    NSSet *inputs = [theController fetchObjectsForEntityName:@"OneTimeExpenseInput"];
    
    NSLog(@"Starting sim engine test ...");
    
    SimEngine *simEngine = [[SimEngine alloc] init ];
    for(OneTimeExpenseInput *input in inputs)
    {
        
        ExpenseInputSimEventCreator *expenseEventCreator =
            [[ExpenseInputSimEventCreator alloc]init];
        expenseEventCreator.expense = input;
        [simEngine.eventCreators addObject:expenseEventCreator];
        [expenseEventCreator release];
        NSLog(@"Results View - Inputs: %@", input.name);
    }
   
    [simEngine runSim];
    NSLog(@"... Done testing sim engine");
    
    [simEngine release];

    
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];

    // This is called before the results view is presented. We use this as
    // an opportunity to update the results. 
    //
    // This should suffice for an initial/prototypical implementation.
    // However, if the number of inputs to process becomes large, then
    // we will likely need to process the inputs and run the simulator engine
    // in the background instead.
	NSLog(@"ResultsViewController: viewWillAppear");
    [self runSimulatorForResults];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
