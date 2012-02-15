//
//  TaxBracketEntryObjectAdder.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxBracketEntryObjectAdder.h"
#import "TaxBracketEntryFormInfoCreator.h"
#import "DataModelController.h"
#import "TaxBracketEntry.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "FinishedAddingTaxBracketEntryListener.h"
#import "FormContext.h"


@implementation TaxBracketEntryObjectAdder

@synthesize taxBracket;
@synthesize dataModelController;

-(id)initWithTaxBracket:(TaxBracket*)theTaxBracket 
	andParentDataModelController:(DataModelController*)parentDataModelController
{
	self = [super init];
	if(self)
	{
		assert(theTaxBracket != nil);
		self.taxBracket = theTaxBracket;
		
		assert(parentDataModelController != nil);
		self.dataModelController = parentDataModelController;
	}
	return self;
}

-(void)addObjectFromTableView:(FormContext*)parentContext
{

	TaxBracketEntry *taxBracketEntry = [self.dataModelController 
							  insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];

	TaxBracketEntryFormInfoCreator *taxBracketEntryFormInfoCreator
		= [[[TaxBracketEntryFormInfoCreator alloc] 
		initWithTaxBracketEntry:taxBracketEntry andIsNewEntry:TRUE] autorelease];

    GenericFieldBasedTableAddViewController *controller = [[[GenericFieldBasedTableAddViewController alloc]
		initWithFormInfoCreator:taxBracketEntryFormInfoCreator
			andNewObject:taxBracketEntry andDataModelController:self.dataModelController] autorelease];
	controller.finshedAddingListener = 
		[[[FinishedAddingTaxBracketEntryListener alloc] initWithTaxBracket:self.taxBracket] autorelease];
    controller.popDepth =1;

    [parentContext.parentController.navigationController pushViewController:controller animated:YES];
}

-(BOOL)supportsAddOutsideEditMode
{
	return FALSE;
}


-(void)dealloc
{
	[taxBracket release];
	[dataModelController release];
	[super dealloc];
}


@end
