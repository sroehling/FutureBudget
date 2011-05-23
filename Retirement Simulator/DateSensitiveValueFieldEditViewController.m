//
//  DateSensitiveValueFieldEditViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueFieldEditViewController.h"
#import "DataModelController.h"
#import "NumberFieldEditViewController.h"
#import "ManagedObjectFieldInfo.h"
#import "FixedValue.h"
#import "VariableValue.h"

@implementation DateSensitiveValueFieldEditViewController

#define FIXED_VALUE_SECTION 0
#define VARIABLE_VALUE_SECTION 1

@synthesize currentValue;
@synthesize variableValues;
@synthesize variableValueEntityName;
@synthesize numberFormatter;
@synthesize fieldInfo;
@synthesize currentFixedValue;
@synthesize addVariableValueButton;

- (id) initWithFieldInfo:(ManagedObjectFieldInfo*)theFieldInfo
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        assert(theFieldInfo != nil);
        self.fieldInfo = theFieldInfo;
    }
    return self;
}


- (void) commidFieldEdit
{
    assert(currentValue != nil);
    [fieldInfo setFieldValue:currentValue]; 
}

- (void) updateVariableValues
{
    assert(variableValueEntityName != nil);
    assert([variableValueEntityName length] > 0);
    self.variableValues = [[DataModelController theDataModelController]
                           fetchSortedObjectsWithEntityName:self.variableValueEntityName sortKey:@"name"];

}

-(void) refreshTable
{
    [self updateVariableValues];
    [self.tableView reloadData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
    self.addVariableValueButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVariableValue)] autorelease];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    
    self.numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
 //   [self.numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [self updateVariableValues];
    
    // TODO - When variable values support milestone dates
    // we'll have to sort by value, then resort using the looked up
    // date value of the milestone date.
    
    self.currentValue = [self.fieldInfo getFieldValue];
    
    if([self.currentValue isKindOfClass:[FixedValue class]])
    {
        self.currentFixedValue = (FixedValue*)self.currentValue;
    }
    else
    {
        FixedValue *fixedValue = (FixedValue*)[[DataModelController theDataModelController] 
                        insertObject:@"FixedValue"];
        fixedValue.value = [NSNumber numberWithDouble:0.0];
        self.currentFixedValue = fixedValue;
    }

    viewPushed = NO;

    
}

- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
    [self refreshTable];
    viewPushed = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
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
            [[DataModelController theDataModelController].managedObjectContext 
             deleteObject:self.currentFixedValue];
            [[DataModelController theDataModelController] saveContext];
        }
        self.currentValue = nil;
        self.currentFixedValue = nil;
        
    }
}

- (IBAction)addVariableValue {
    
    VariableValue *newVariableValue = (VariableValue*)[[DataModelController theDataModelController] insertObject:self.variableValueEntityName];
    newVariableValue.name = @"New Value";
    newVariableValue.startingValue = [NSNumber numberWithDouble:0.0];
    [[DataModelController theDataModelController] saveContext];
    
    // Refresh the table to include the new value
    [self refreshTable];
}



#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case FIXED_VALUE_SECTION:
            title = @"Fixed Value";
            break;
        case VARIABLE_VALUE_SECTION:
            title = @"Variable Value";
            break;
        default:
            assert(0);
            break;
    }
    return title;;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == FIXED_VALUE_SECTION)
    {
        return 1;
    }
    else
    {
        assert(section == VARIABLE_VALUE_SECTION);
        return [self.variableValues count];
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    if(indexPath.section == FIXED_VALUE_SECTION)
    {
        assert(indexPath.row == 0);
        cell.textLabel.text = @"Value";
        NSLog(@"Setting value: %@",[self.numberFormatter stringFromNumber:self.currentFixedValue.value]);
        cell.detailTextLabel.text = [self.numberFormatter stringFromNumber:self.currentFixedValue.value];
        cell.accessoryType = 
            (self.currentValue == self.currentFixedValue)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;

    }
    else
    {
        assert(indexPath.section == VARIABLE_VALUE_SECTION);
        VariableValue *valueForRow = [self.variableValues objectAtIndex:indexPath.row];
        cell.accessoryType = 
        (self.currentValue == valueForRow)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;

        cell.detailTextLabel.text = valueForRow.name;
    }
    return cell;
}



- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

-(void)uncheckCurrentSelection
{
    NSIndexPath *selectionIndexPath;
    if(self.currentValue == self.currentFixedValue)
    {
        selectionIndexPath = [NSIndexPath 
                              indexPathForRow:0 inSection:FIXED_VALUE_SECTION];
        
    }
    else
    {
        NSInteger index = [self.variableValues indexOfObject:self.currentValue];
        assert(index >= 0);
        assert(index < [self.variableValues count]);
        selectionIndexPath = [NSIndexPath indexPathForRow:index inSection:VARIABLE_VALUE_SECTION];
    }
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
    
    if(newPath.section == FIXED_VALUE_SECTION)
    {
        self.currentValue = self.currentFixedValue;
    }
    else
    {
        VariableValue *selectedValue = [self.variableValues objectAtIndex:newPath.row];
        assert(selectedValue != nil);
        self.currentValue = selectedValue;
    }
    
    // When selecting (putting a checkmark) on a new value, update the field value immediately.
    // TBD - is this the desired behavior - or should there be a manual "save" operation, like
    // the for the other field edits.
    [self commidFieldEdit];

}

/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	    
    if(self.editing)
    {
        UIViewController *controller;
        if(indexPath.section == FIXED_VALUE_SECTION)
        {
            assert(indexPath.row == 0);
            
            ManagedObjectFieldInfo *fixedValueFieldInfo = [[[ManagedObjectFieldInfo alloc] 
                                                            initWithManagedObject:currentFixedValue 
                                                            andFieldKey:@"value" andFieldLabel:@"Value"] autorelease];
            
            
            NumberFieldEditViewController *numberController = 
            [[[NumberFieldEditViewController alloc] initWithNibName:@"NumberFieldEditViewController" 
                                                       andFieldInfo:fixedValueFieldInfo] autorelease];
            controller = numberController;
        }
        else
        {
            assert(indexPath.section == VARIABLE_VALUE_SECTION);
            assert(0);
        }
        viewPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else
    {
        // Move the checkmark to the newly selected value
        [self uncheckCurrentSelection];
        [self checkNewSelection:indexPath];

    }
	
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


- (void)dealloc
{
    [super dealloc];
  
    [currentValue release];
    [currentFixedValue release];
    [variableValues release];
    [variableValueEntityName release];
    [fieldInfo release];
    [addVariableValueButton release];

}


#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
	[self.navigationItem setHidesBackButton:editing animated:NO];
	
    if(editing)
    {
        self.navigationItem.leftBarButtonItem = self.addVariableValueButton;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        
        // Done editing - save context
        [[DataModelController theDataModelController] saveContext];
    }
}

@end
