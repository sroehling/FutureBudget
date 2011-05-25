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


@implementation GenericFieldBasedTableEditViewController

@synthesize fieldEditInfo;

-(id)initWithFieldEditInfo:(NSMutableArray *)theFieldEditInfo
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self)
    {
        assert(theFieldEditInfo!=nil);
        assert([theFieldEditInfo count] > 0);
        self.fieldEditInfo = theFieldEditInfo;
        
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.tableView.allowsSelectionDuringEditing = YES;

    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    assert(0); // should not call this version of init
}

- (id)init
{
    assert(0); // should not call this version of init
}

- (void)dealloc
{
    [super dealloc];
    [fieldEditInfo release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
    [self.tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // The fieldEditInfo vector must be initialized and have > 0 field info objects
    // for this table view to be properly configured.
    assert(self.fieldEditInfo != nil);
    assert([self.fieldEditInfo count] > 0);
    
    return [self.fieldEditInfo count];
}



- (id<FieldEditInfo>)fieldEditInfoAtIndex:(NSUInteger)theIndex
{
    assert(theIndex < [self.fieldEditInfo count]);
    id<FieldEditInfo> fieldEditInfoForRow = (id<FieldEditInfo>)[self.fieldEditInfo objectAtIndex:theIndex];
    assert(fieldEditInfoForRow != nil);
    return fieldEditInfoForRow;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    id<FieldEditInfo> fieldEditInfoForRow = [self fieldEditInfoAtIndex:indexPath.row];    
    UITableViewCell *cell = [fieldEditInfoForRow cellForFieldEdit:tableView];
    assert(cell != nil);
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
    return indexPath;
}



/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    id<FieldEditInfo> fieldEditInfoForRow = [self fieldEditInfoAtIndex:indexPath.row];
    
    // Deselect the row.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([fieldEditInfoForRow hasFieldEditController])
    {
        UIViewController *viewControllerForRow = [fieldEditInfoForRow fieldEditController];
        assert(viewControllerForRow != nil);
        [self.navigationController pushViewController:viewControllerForRow animated:YES];       
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
	[self.navigationItem setHidesBackButton:editing animated:NO];
	
    if(editing)
    {
    }
    else
    {        
        // Done editing - save context
        [[DataModelController theDataModelController] saveContext];
    }
}



@end
