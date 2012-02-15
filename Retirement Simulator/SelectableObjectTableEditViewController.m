//
//  SelectableObjectTableEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectableObjectTableEditViewController.h"
#import "ManagedObjectFieldInfo.h"
#import "DataModelController.h"
#import "FieldEditInfo.h"
#import "FormInfo.h"


@implementation SelectableObjectTableEditViewController

@synthesize assignedField;
@synthesize closeAfterSelection;

@synthesize loadInEditModeIfAssignedFieldNotSet;

- (id) initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator 
          andAssignedField:(FieldInfo*)theAssignedField
		  andDataModelController:(DataModelController*)theDataModelController
{
    self = [super initWithFormInfoCreator:theFormInfoCreator 
		andDataModelController:theDataModelController];
    if(self)
    {
        assert(theAssignedField != nil);
        self.assignedField = theAssignedField;
		self.closeAfterSelection = FALSE; // default
		self.loadInEditModeIfAssignedFieldNotSet = FALSE;
		
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
		self.tableView.allowsSelectionDuringEditing = YES;

    }
    return self;
}

-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator
{
    assert(0); // must call init method with assigned field info
}


- (void)dealloc
{
    [assignedField release];
    [super dealloc];
}


#pragma mark - Helpers to manage the selection of the checkmark and updating of values

- (void)setAssignedValueFromCurrentlySelectedRow
{
	// The code below originates from uses of this class with a 
	// DateSensitiveValueFormInfoCreator. 
	// 
	// See the lengthly comment in DateSensitiveValueFormInfoCreator 
	// for a comprehensive discussion why this code is necessary.
	id<FieldEditInfo> feInfo = [self.formInfo findSelectedFieldEditInfo];
	assert(feInfo != nil);
	NSManagedObject *newValue = [feInfo managedObject];
	assert(newValue != nil);
	[self.assignedField setFieldValue:newValue]; 
}



- (void)moveSelection:(NSIndexPath*)newPath
{

	// Uncheck the current selection, if there is one
	id<FieldEditInfo> currentSelectionRowFieldEditInfo = [self.formInfo findSelectedFieldEditInfo];
	if(currentSelectionRowFieldEditInfo != nil)
	{
		assert([currentSelectionRowFieldEditInfo respondsToSelector: @selector(updateSelection:)]);
		[currentSelectionRowFieldEditInfo updateSelection:FALSE];
		assert([currentSelectionRowFieldEditInfo managedObject] != nil);
		NSIndexPath *currentlySelectedIndex = [self.formInfo 
			pathForObject:[currentSelectionRowFieldEditInfo managedObject]];
		assert(currentlySelectedIndex != nil);
		UITableViewCell *currentlyCheckedCell = [self.tableView cellForRowAtIndexPath:currentlySelectedIndex];
		assert(currentlyCheckedCell != nil);
		currentlyCheckedCell.accessoryType  = UITableViewCellAccessoryNone;
	}
	
	id<FieldEditInfo> newSelectionRowFieldEditInfo = [self.formInfo fieldEditInfoIndexPath:newPath];
	assert(newSelectionRowFieldEditInfo != nil);
	assert([newSelectionRowFieldEditInfo respondsToSelector: @selector(updateSelection:)]);
	[newSelectionRowFieldEditInfo updateSelection:TRUE];


    UITableViewCell *checkedCell = [self.tableView cellForRowAtIndexPath:newPath];
    assert(checkedCell!=nil);
    checkedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Deselect the row.
    [self.tableView deselectRowAtIndexPath:newPath animated:YES];
  
	[self setAssignedValueFromCurrentlySelectedRow];
	
	if(self.closeAfterSelection)
	{
		[self.navigationController popViewControllerAnimated:TRUE];
	}
    
}


-(void)updateSelectionFromFieldValue
{
	if([self.assignedField fieldIsInitializedInParentObject])
	{
		NSManagedObject *currentValue = [self.assignedField getFieldValue];
		assert(currentValue != nil);
		
		NSIndexPath *currentValueIndex = [self.formInfo pathForObject:currentValue];
		assert(currentValueIndex != nil);
		[self moveSelection:currentValueIndex];

	}
}



#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
		
    [self.tableView reloadData];
	
	[self.formInfo unselectAllFields];
	
	if([self.assignedField fieldIsInitializedInParentObject])
	{
		[self updateSelectionFromFieldValue];
	}
	else
	{
		id<FieldEditInfo> defaultSelection = [self.formInfo findDefaultSelection];
		if(defaultSelection != nil)
		{
			[defaultSelection updateSelection:TRUE];
		}

		if(self.loadInEditModeIfAssignedFieldNotSet)
		{
			self.editing = true;
		}

	}

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    assert(theCell != nil);

	id<FieldEditInfo> fieldEditInfoForRow = [self.formInfo fieldEditInfoIndexPath:indexPath];
	assert(fieldEditInfoForRow != nil);
	assert([fieldEditInfoForRow respondsToSelector: @selector(isSelected)]);

	if([fieldEditInfoForRow isSelected])
	{
		theCell.accessoryType = UITableViewCellAccessoryCheckmark;		
	}
	else
	{
        theCell.accessoryType = UITableViewCellAccessoryNone;
	}
		
	return theCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.editing)
    {
        // Calling super's didSelectRowAtIndexPath will fetch the field edit 
        // info object for the given path and push the associated controller
        // We only do this in edit mode, so that while not in edit mode we can
        // just move the selection.
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    else
    {
        // Move the checkmark to the newly selected value
        [self moveSelection:indexPath];
        
    }
	
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
	if(!editing)
	{
	
		// Coming out of edit mode, the managed object associated
		// with the currently selected row could have changed. This
		// is the case, for example, when the row manages a multi-scenario
		// object. To support this case, we need to update the assignment
		// upon return from edit mode (since the RHS of the assignment
		// to assignedField could have changed.
		[self setAssignedValueFromCurrentlySelectedRow];
					      
		// Done editing - do a "soft save" of the context.
		[self.dataModelController saveContextAndIgnoreErrors];
	}
	
    [super setEditing:editing animated:animated];
    
	[self.navigationItem setHidesBackButton:editing animated:NO];
	
}

@end
