//
//  GenericFieldBasedTableEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GenericFieldBasedTableEditViewController.h"
#import "FieldEditInfo.h"
#import "DataModelController.h"
#import "FormInfo.h"
#import "WEPopoverController.h"
#import "StringValidation.h"
#import "TextCaptionWEPopoverContainer.h"
#import "UIHelper.h"
#import "FormContext.h"

@implementation GenericFieldBasedTableEditViewController

@synthesize addButton;
@synthesize addButtonPopoverController;

-(BOOL)showAddButtonOutsideEditMode
{
	if((self.formInfo.objectAdder != nil) &&
		[self.formInfo.objectAdder supportsAddOutsideEditMode])
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

-(BOOL)showAddButtonInEditMode
{
	return (self.formInfo.objectAdder != nil)?TRUE:FALSE;
}

-(BOOL)doShowAddButtonCaptionPopover
{
	if((!self.editing) && 
	   [self showAddButtonInEditMode] && 
	   ([self.formInfo numSections] == 0) &&
	   ((self.formInfo.addButtonPopoverInfo != nil)))
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}


-(void)showAddButtonCaptionPopover
{

	TextCaptionWEPopoverContainer *popoverContainer = [[[TextCaptionWEPopoverContainer
		alloc] initWithCaptionInfo:self.formInfo.addButtonPopoverInfo] autorelease];
	self.addButtonPopoverController = [[WEPopoverController alloc] 
		initWithContentViewController:popoverContainer];

	self.addButtonPopoverController.passthroughViews = [NSArray arrayWithObject:self.view];

	assert([self.addButtonPopoverController respondsToSelector:@selector(setContainerViewProperties:)]);
	[self.addButtonPopoverController setContainerViewProperties:[popoverContainer containerViewProperties]];

	[self.addButtonPopoverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem 
	  permittedArrowDirections:UIPopoverArrowDirectionUp animated:TRUE];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.addButton = [[[UIBarButtonItem alloc]   
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd   
                                  target:self   
                                  action:@selector(insertNewObject)] autorelease];
								  
	self.navigationItem.leftBarButtonItem = [self showAddButtonOutsideEditMode]?self.addButton:nil;
}


-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if([self doShowAddButtonCaptionPopover])
	{
		[self showAddButtonCaptionPopover];
	}

}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if(self.addButtonPopoverController != nil)
	{
		[self.addButtonPopoverController dismissPopoverAnimated:FALSE];
		self.addButtonPopoverController = nil;
	}
}



#pragma mark -
#pragma mark Table view data source methods


- (void)tableView:(UITableView *)tableView 
	commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
	forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // If row is deleted, remove it from the list.
	
	id<FieldEditInfo> fieldEditInfoForRow = [self.formInfo fieldEditInfoIndexPath:indexPath];
	
	assert([fieldEditInfoForRow respondsToSelector: @selector(supportsDelete)]);
	assert([fieldEditInfoForRow supportsDelete]);
	assert([fieldEditInfoForRow respondsToSelector: @selector(deleteObject:)]);
	
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		[fieldEditInfoForRow deleteObject:self.dataModelController];
		[self.formInfo removeFieldEditInfo:indexPath];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
			withRowAnimation:UITableViewRowAnimationFade];
    }
}



#pragma mark -
#pragma mark Editing

- (void)insertNewObject
{
	if(self.formInfo.objectAdder != nil)
	{
		FormContext *formContext = [[[FormContext alloc] 
			initWithParentController:self 
			andDataModelController:self.dataModelController] autorelease];
		[self.formInfo.objectAdder addObjectFromTableView:formContext];
	}
}




- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
	if(!editing)
	{
		// If there is a current first responder (typically text field),
		// only allow the table to exit edit mode if the that responder
		// is willing to resign it's first responder status. This is 
		// applicable in scenarios where the user is entering something
		// into a text field, and it must be well-formed/valid before 
		// exiting edit mode.
		if([self.tableView findAndAskForResignationOfFirstResponder])
		{
			[super setEditing:editing animated:animated];
			
			[self.navigationItem setHidesBackButton:editing animated:NO];
			[self.dataModelController saveContextAndIgnoreErrors];
			
			if(![self showAddButtonOutsideEditMode])
			{
				self.navigationItem.leftBarButtonItem = nil;
			}
		}
	}
	else
	{
		[super setEditing:editing animated:animated];
		if([self showAddButtonInEditMode])
		{
			self.navigationItem.leftBarButtonItem = self.addButton; 			
		}
		
		[self.navigationItem setHidesBackButton:editing animated:NO];
		
	}	
 }
 
 
 - (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
	editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	id<FieldEditInfo> fieldEditInfoForRow = [self.formInfo fieldEditInfoIndexPath:indexPath];
	assert(fieldEditInfoForRow != nil);

	if([fieldEditInfoForRow respondsToSelector: @selector(supportsDelete)])
	{
		if([fieldEditInfoForRow supportsDelete])
		{
			return UITableViewCellEditingStyleDelete;
		}
		else 
		{
			return UITableViewCellEditingStyleNone;
		}
	}
	else
	{
		return UITableViewCellEditingStyleNone;
	}
}


 
 - (void) dealloc
 {
	 [addButton release];
	 [addButtonPopoverController release];
	 [super dealloc];
 }



@end
