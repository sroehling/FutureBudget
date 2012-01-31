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


@implementation TaxBracketEntryObjectAdder

@synthesize taxBracket;

-(id)initWithTaxBracket:(TaxBracket*)theTaxBracket
{
	self = [super init];
	if(self)
	{
		assert(theTaxBracket != nil);
		self.taxBracket = theTaxBracket;
	}
	return self;
}

-(void)addObjectFromTableView:(UITableViewController*)parentView
{

	TaxBracketEntry *taxBracketEntry = [[DataModelController theDataModelController] 
							  insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];

	TaxBracketEntryFormInfoCreator *taxBracketEntryFormInfoCreator
		= [[[TaxBracketEntryFormInfoCreator alloc] 
		initWithTaxBracketEntry:taxBracketEntry andIsNewEntry:TRUE] autorelease];

    GenericFieldBasedTableAddViewController *controller = [[[GenericFieldBasedTableAddViewController alloc]
		initWithFormInfoCreator:taxBracketEntryFormInfoCreator
			andNewObject:taxBracketEntry] autorelease];
	controller.finshedAddingListener = 
		[[[FinishedAddingTaxBracketEntryListener alloc] initWithTaxBracket:self.taxBracket] autorelease];
    controller.popDepth =1;

    [parentView.navigationController pushViewController:controller animated:YES];
}

-(BOOL)supportsAddOutsideEditMode
{
	return FALSE;
}


-(void)dealloc
{
	[super dealloc];
	[taxBracket release];
}


@end
