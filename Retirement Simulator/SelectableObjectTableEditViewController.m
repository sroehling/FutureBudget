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
@synthesize currentValue;
@synthesize currentValueIndex;
@synthesize closeAfterSelection;

- (id) initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator 
          andAssignedField:(FieldInfo*)theAssignedField
{
    self = [super initWithFormInfoCreator:theFormInfoCreator];
    if(self)
    {
        assert(theAssignedField != nil);
        self.assignedField = theAssignedField;
		self.closeAfterSelection = FALSE; // default
    }
    return self;
}

-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator
{
    assert(0); // must call init method with assigned field info
}


- (void)dealloc
{
    [super dealloc];
    
    [assignedField release];
    [currentValue release];
    [currentValueIndex release];
}


#pragma mark - View lifecycle

- (void) commidFieldEdit
{
    assert(self.currentValue != nil);
    [self.assignedField setFieldValue:self.currentValue]; 
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
    if(self.currentValue != nil)
    {
        self.currentValueIndex = [self.formInfo pathForObject:self.currentValue];        
    }
    else
    {
        self.currentValueIndex = nil;
    }
    [self.tableView reloadData];

}


- (void)updateCurrentValue:(NSManagedObject*)newVal
{
    assert(newVal != nil);
    NSLog(@"Updating current value to: %@",[newVal description]);
    self.currentValue = newVal;
    self.currentValueIndex = [self.formInfo pathForObject:newVal];
    
}

-(void)uncheckCurrentSelection
{
    if(self.currentValue != nil)
    {
        NSIndexPath *selectionIndexPath = [self.formInfo pathForObject:self.currentValue];      
        UITableViewCell *checkedCell = [self.tableView cellForRowAtIndexPath:selectionIndexPath];
        if(checkedCell != nil)
		{
			checkedCell.accessoryType = UITableViewCellAccessoryNone;
		}
    }

}

- (void)checkNewSelection:(NSIndexPath*)newPath
{
    UITableViewCell *checkedCell = [self.tableView cellForRowAtIndexPath:newPath];
    assert(checkedCell!=nil);
    checkedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Deselect the row.
    [self.tableView deselectRowAtIndexPath:newPath animated:YES];
  
    [self updateCurrentValue:[self.formInfo objectAtPath:newPath]];

    [self commidFieldEdit];
	
	if(self.closeAfterSelection)
	{
		[self.navigationController popViewControllerAnimated:TRUE];
	}
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    assert(theCell != nil);

    if(self.currentValue != nil)
    {
        NSIndexPath *selectionIndexPath = [self.formInfo pathForObject:self.currentValue];
        if(selectionIndexPath.section == indexPath.section && 
           selectionIndexPath.row == indexPath.row)
        {
            theCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        else
        {
            theCell.accessoryType = UITableViewCellAccessoryNone;
        }        
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
        [self uncheckCurrentSelection];
        [self checkNewSelection:indexPath];
        
    }
	
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
	[self.navigationItem setHidesBackButton:editing animated:NO];
	
    if(!editing)
    {
        // Done editing - save context
        [[DataModelController theDataModelController] saveContext];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
   
    
    // Only update the current value (i.e., the initial value checked-off in the table)
    // if a value has already been set in the property of the object being
    // modified.
    if([self.assignedField fieldIsInitializedInParentObject])
    {
        [self updateCurrentValue:[self.assignedField getFieldValue]];      
    }    
}


@end
