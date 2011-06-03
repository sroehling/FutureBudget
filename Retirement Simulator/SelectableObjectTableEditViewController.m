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
@synthesize formInfoCreator;
@synthesize currentValue;
@synthesize currentValueIndex;

- (id) initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator 
          andAssignedField:(ManagedObjectFieldInfo*)theAssignedField
{
    assert(theFormInfoCreator != nil);
    
    // Initially pass in an empty FormInfo object. It will be fully
    // re-populatee with viewDidLoad.
    FormInfo *initialFormInfo = [[[FormInfo alloc]init ] autorelease];
    initialFormInfo.title = @"Dummy";
    
    self = [super initWithFormInfo:initialFormInfo];
    if(self)
    {
        assert(theAssignedField != nil);
        self.assignedField = theAssignedField;
        self.formInfoCreator = theFormInfoCreator;
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
    
    [assignedField release];
    [formInfoCreator release];
    [currentValue release];
    [currentValueIndex release];
}


#pragma mark - View lifecycle

- (void) commidFieldEdit
{
    assert(self.currentValue != nil);
    [self.assignedField setFieldValue:self.currentValue]; 
}

-(void) refreshTable
{
    self.formInfo = [self.formInfoCreator createFormInfo:self];
    self.currentValueIndex = [self.formInfo pathForObject:self.currentValue];
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
   [self refreshTable];
//    viewPushed = NO; */
}


- (void)viewWillDisappear:(BOOL)animated
{
    /*
    [super viewWillDisappear:animated];
    // Used the viewPushed property to track whether the view is disappearing because
    // the back button is being pressed or if we're pushing into another view. Only
    // when the back button is pressed to we check if we need to delete the fixed
    // value object.
    if(viewPushed)
    {
        viewPushed = NO;
    }
    else
    {
        // If upon unloading the view the fixed value is no longer selected,
        // we can delete it. This is because fixed values are only referenced
        // by a single input, unlike variable/shared values which can be referenced
        // by multiple inputs.
        if(self.currentValue != self.currentFixedValue)
        {
            [[DataModelController theDataModelController] deleteObject:self.currentValue];
        }
        self.currentValue = nil;
        self.currentFixedValue = nil;
        
    } */
}

- (void)updateCurrentValue:(NSManagedObject*)newVal
{
    assert(newVal != nil);
    self.currentValue = newVal;
    self.currentValueIndex = [self.formInfo pathForObject:newVal];
    
}

-(void)uncheckCurrentSelection
{
    assert(self.currentValue != nil);
    NSIndexPath *selectionIndexPath = [self.formInfo pathForObject:self.currentValue];
    UITableViewCell *checkedCell = [self.tableView cellForRowAtIndexPath:selectionIndexPath];
    assert(checkedCell!=nil);
    checkedCell.accessoryType = UITableViewCellAccessoryNone;
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
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    assert(theCell != nil);
    assert(self.currentValue != nil);
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
	
    if(editing)
    {
   //     self.navigationItem.leftBarButtonItem = self.addVariableValueButton;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        
        // Done editing - save context
     //   [[DataModelController theDataModelController] saveContext];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /*
    self.addVariableValueButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVariableValue)] autorelease];
    
    */
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
   
    self.formInfo = [self.formInfoCreator createFormInfo:self];
    [self updateCurrentValue:[self.assignedField getFieldValue]];
 
    
    /*
    viewPushed = NO;
    */
    
}


@end
