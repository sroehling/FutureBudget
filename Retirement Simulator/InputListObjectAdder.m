//
//  InputListObjectAdder.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputListObjectAdder.h"
#import "InputTypeSelectionFormInfoCreator.h"
#import "SelectableObjectCreationTableViewController.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "DetailInputViewCreator.h"
#import "DataModelController.h"
#import "FormContext.h"
#import "TableViewHelper.h"
#import "AppHelper.h"
#import "Input.h"

@implementation InputListObjectAdder

@synthesize dmcForNewInputs;
@synthesize currentContext;

-(void)dealloc
{
	[dmcForNewInputs release];
	[currentContext release];
	[super dealloc];
}

-(void)addObjectFromTableView:(FormContext*)parentContext
{

	// Initialize dmcForNewInputs to a new DataModelController, so changes associated with
	// the new object are kept isolated from other changes, and can
	// be saved all at once when the new input has been fully populated
	// and validated.
	self.dmcForNewInputs = [AppHelper subDataModelControllerForCurrentPlan];
	
	self.currentContext = parentContext;

	InputTypeSelectionFormInfoCreator *inputSelectionFormInfoCreator =
		[[[InputTypeSelectionFormInfoCreator alloc]
		initWithDmcForNewInputs:self.dmcForNewInputs
		andInputSelectedForCreationDelegate:self] autorelease];
		
	SelectableObjectCreationTableViewController *inputCreationViewController
		= [[[SelectableObjectCreationTableViewController alloc]
			initWithFormInfoCreator:inputSelectionFormInfoCreator
			andDataModelController:parentContext.dataModelController] autorelease];
	inputCreationViewController.delegate = self;

    [parentContext.parentController.navigationController
		pushViewController:inputCreationViewController animated:YES];
}

-(BOOL)supportsAddOutsideEditMode
{
	return TRUE;
}

-(void)objectCreatedFromSelection:(NSManagedObject *)createdObj
{
	Input *theNewInput = (Input*)createdObj;
	assert(theNewInput != nil);
	
    DetailInputViewCreator *detailViewCreator = [[[DetailInputViewCreator alloc] 
                        initWithInput:theNewInput andIsForNewObject:TRUE] autorelease];
    
	// Create a new data model controller for the inputs. This keeps any un-validated
	// additions isolated w.r.t. other changes.
    
    GenericFieldBasedTableAddViewController *addView =  [[[GenericFieldBasedTableAddViewController alloc] 
        initWithFormInfoCreator:detailViewCreator andNewObject:theNewInput
		andDataModelController:self.dmcForNewInputs] autorelease];
	addView.disableCoreDataSaveUntilSaveButtonPressed = TRUE;
	
	NSInteger currentViewControllerDepth = [TableViewHelper viewControllerDepth:self.currentContext.parentController];
	
	// The controller depth will be 0, 1, 2, etc. where the controller is at 0 depth is the input list.
	// An input can be created with an GenericFieldBasedTableAddViewController at depth 2 or 3 (for tax inputs).
	// Pushing the view controller below will add one to the view controller depth. Popping by the current depth
	// will have the effect of popping all but the last view controller, which is the input list.
	addView.popDepth = currentViewControllerDepth+1;

     
	[self.currentContext.parentController.navigationController
		pushViewController:addView animated:YES];
}

@end
