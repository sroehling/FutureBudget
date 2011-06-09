//
//  VariableValueViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueViewController.h"
#import "DataModelController.h"
#import "ManagedObjectFieldInfo.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "VariableValue.h"
#import "DateSensitiveValueChange.h"
#import "NumberFieldEditViewController.h"
#import "TextFieldEditViewController.h"
#import "StaticFormInfoCreator.h"
#import "CollectionHelper.h"
#import "TableViewHelper.h"
#import "NumberHelper.h"

#import "ManagedObjectFieldInfo.h"
#import "TextFieldEditInfo.h"
#import "FormInfo.h"
#import "FormPopulator.h"
#import "NumberFieldEditInfo.h"
#import "VariableValueRuntimeInfo.h"
#import "DateFieldEditInfo.h"
#import "SectionInfo.h"




@implementation VariableValueViewController

@synthesize variableValue;
@synthesize valueChanges;
@synthesize addValueChangeButton;
@synthesize nameFieldEditInfo;
@synthesize startingValFieldEditInfo;
@synthesize varValRuntimeInfo;

#define SECTION_MAIN 0
#define SECTION_VALUE_CHANGES 1

- (id)initWithVariableValue:(VariableValue*)theValue
	andVarValueRuntimeInfo:(VariableValueRuntimeInfo*)theVarValRuntimeInfo
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        assert(theValue != nil);
        self.variableValue = theValue;
		
		assert(theVarValRuntimeInfo != nil);
		self.varValRuntimeInfo = theVarValRuntimeInfo;
        
        self.nameFieldEditInfo = [TextFieldEditInfo createForObject:self.variableValue 
                    andKey:@"name" andLabel:@"Name"];
        self.startingValFieldEditInfo = [NumberFieldEditInfo createForObject:self.variableValue
                    andKey:@"startingValue" andLabel:@"Starting" andNumberFormatter:self.varValRuntimeInfo.valueFormatter];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [variableValue release];
    [valueChanges release];
    [addValueChangeButton release];
    [nameFieldEditInfo release];
    [startingValFieldEditInfo release];
	[varValRuntimeInfo release];
}


#pragma mark - View lifecycle

- (void)refreshTable 
{
    self.valueChanges = [CollectionHelper setToSortedArray:
                         self.variableValue.valueChanges withKey:@"startDate"];
    [self.tableView reloadData];
}


- (IBAction)addValueChange {
    
    DateSensitiveValueChange *dsValueChange = (DateSensitiveValueChange*)[[DataModelController theDataModelController] insertObject:@"DateSensitiveValueChange"];
    dsValueChange.startDate = [[[NSDate alloc]init] autorelease];
    dsValueChange.newValue = [NSNumber numberWithDouble:0.0];
    [self.variableValue addValueChangesObject:dsValueChange];
    
    [[DataModelController theDataModelController] saveContext];
    
    // Refresh the table to include the new value
    [self refreshTable];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addValueChangeButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addValueChange)] autorelease];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    

}

- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
    [self refreshTable];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case SECTION_MAIN:
            title = @"Starting Value";
            break;
        case SECTION_VALUE_CHANGES:
            title = @"Value Changes";
            break;
        default:
            assert(0);
            break;
    }
    return title;;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == SECTION_MAIN)
    {
        return 2;
    }
    else
    {
        assert(section == SECTION_VALUE_CHANGES);
        return [self.valueChanges count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section == SECTION_MAIN)
    {
        assert([[NumberHelper theHelper]valueInRange:indexPath.row lower:0 upper:1]);
        if(indexPath.row == 0)
        {
            cell = [self.nameFieldEditInfo cellForFieldEdit:self.tableView];
            
        }
        else
        {
            cell = [self.startingValFieldEditInfo cellForFieldEdit:self.tableView];
        }
        
    }
    else
    {
        cell = [TableViewHelper reuseOrAllocCell:self.tableView];
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        assert(indexPath.section == SECTION_VALUE_CHANGES);
        DateSensitiveValueChange *valueChange = 
            (DateSensitiveValueChange*)[self.valueChanges objectAtIndex:indexPath.row];
        assert(valueChange != nil);

        cell.detailTextLabel.text = @"Value Change";
    }    
    assert(cell != nil);
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.editing)
    {
        UIViewController *controller;
        if(indexPath.section == SECTION_MAIN)
        {
            assert((indexPath.row == 0) || (indexPath.row == 1));
            if(indexPath.row == 0)
            {
                controller = [TextFieldEditViewController createControllerForObject:self.variableValue andFieldKey:@"name" andFieldLabel:@"Name"];
                
            }
            else
            {
                controller = [NumberFieldEditViewController createControllerForObject:self.variableValue andFieldKey:@"startingValue" andFieldLabel:@"Starting"];
            }
            
        }
        else
        {
            assert(indexPath.section == SECTION_VALUE_CHANGES);
            
            
            DateSensitiveValueChange *valueChange = 
                (DateSensitiveValueChange*)[self.valueChanges objectAtIndex:indexPath.row];
            assert(valueChange != nil);
            
            
            FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
            formPopulator.formInfo.title = @"Value Change";

            SectionInfo *sectionInfo = [formPopulator nextSection];
            [sectionInfo addFieldEditInfo:[DateFieldEditInfo createForObject:valueChange andKey:@"startDate" andLabel:@"Date"]];
            [sectionInfo addFieldEditInfo:[NumberFieldEditInfo 
                    createForObject:valueChange andKey:@"newValue" andLabel:@"New Value"
					andNumberFormatter:self.varValRuntimeInfo.valueFormatter]];

 
            controller = [[[GenericFieldBasedTableEditViewController alloc] 
                           initWithFormInfoCreator:[StaticFormInfoCreator 
                                createWithFormInfo:formPopulator.formInfo]] autorelease];
            
        }
        assert(controller != nil);
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

#pragma mark -
#pragma mark Editing

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
	[self.navigationItem setHidesBackButton:editing animated:NO];
	
    if(editing)
    {
        self.navigationItem.leftBarButtonItem = self.addValueChangeButton;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        
        // Done editing - save context
        [[DataModelController theDataModelController] saveContext];
    }
}

@end