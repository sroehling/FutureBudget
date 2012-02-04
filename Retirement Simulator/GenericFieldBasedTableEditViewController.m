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


@implementation UIView(findAndAskForResignationOfFirstResponder)



-(UIView*)findFirstResponderInSubviews
{
	if(self.isFirstResponder)
	{
		return self;
	}
	else
	{
		for(UIView *subView in self.subviews)
		{
			UIView *subViewFR = [subView findFirstResponderInSubviews];
			if(subViewFR != nil)
			{
				return subViewFR;
			}
		}
	}
	return nil;
}

-(BOOL)findAndAskForResignationOfFirstResponder
{    

	UIView *firstResponder = [self findFirstResponderInSubviews];
	if(firstResponder != nil)
	{
		if([firstResponder canResignFirstResponder])
		{
			return YES;
		}
		else
		{
			return NO;
		}
	}
	else
	{
		return YES;
	}
}

@end

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
	   ((self.formInfo.emptyFormObjectAddPopupCaption != nil)))
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
	assert([StringValidation nonEmptyString:self.formInfo.emptyFormObjectAddPopupCaption]);

	TextCaptionWEPopoverContainer *popoverContainer = [[[TextCaptionWEPopoverContainer
		alloc] initWithCaption:self.formInfo.emptyFormObjectAddPopupCaption] autorelease];
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
	assert([fieldEditInfoForRow respondsToSelector: @selector(deleteObject)]);
	
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		[fieldEditInfoForRow deleteObject];
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
		[self.formInfo.objectAdder addObjectFromTableView:self];
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
			[[DataModelController theDataModelController] saveContextAndIgnoreErrors];
			
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
	 [super dealloc];
	 [addButton release];
	 [addButtonPopoverController release];
 }



@end
