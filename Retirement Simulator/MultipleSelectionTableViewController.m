//
//  MultipleSelectionTableViewController.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MultipleSelectionTableViewController.h"
#import "DataModelController.h"


@implementation MultipleSelectionTableViewController



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
	
    // Redisplay the data - notably, this is invoked when returning 
    // from an editor for one of the field values,
    // causing the display of these values to refresh if changed.
    [self.tableView reloadData];

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
		// Just update the check/selection mark, but don't hightlight the row to indicate
		// it is selected.
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
		id<FieldEditInfo> fieldEditInfoForRow = [self.formInfo fieldEditInfoIndexPath:indexPath];
		assert(fieldEditInfoForRow != nil);
		
		assert([fieldEditInfoForRow respondsToSelector: @selector(isSelected)]);
		assert([fieldEditInfoForRow respondsToSelector: @selector(updateSelection:)]);

		UITableViewCell *cellForRow = [self.tableView cellForRowAtIndexPath:indexPath];
		assert(cellForRow!=nil);
		
		// Toggle the selection
		if(cellForRow.accessoryType == UITableViewCellAccessoryCheckmark)
		{
			cellForRow.accessoryType = UITableViewCellAccessoryNone;
			[fieldEditInfoForRow updateSelection:FALSE];
		}
		else
		{
			cellForRow.accessoryType = UITableViewCellAccessoryCheckmark;
			[fieldEditInfoForRow updateSelection:TRUE];
		}

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
   
}


@end
