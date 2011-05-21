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


    
}

- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
    [self refreshTable];
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
  //      cell.textLabel.text = valueForRow.name;
        cell.detailTextLabel.text = valueForRow.name;
    }
    return cell;
}



- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
    return (self.editing) ? indexPath : nil;
}

/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (!self.editing) return;
    
    
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
    [self.navigationController pushViewController:controller animated:YES];
	
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
