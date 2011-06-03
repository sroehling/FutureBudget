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


@implementation GenericFieldBasedTableEditViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
}

#pragma mark -
#pragma mark Table view data source methods


/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    id<FieldEditInfo> fieldEditInfoForRow = [self.formInfo fieldEditInfoIndexPath:indexPath];
    
    // Deselect the row.
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([fieldEditInfoForRow hasFieldEditController])
    {
        UIViewController *viewControllerForRow = [fieldEditInfoForRow fieldEditController];
        assert(viewControllerForRow != nil);
        [self.navigationController pushViewController:viewControllerForRow animated:YES];       
    }
}



#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
	[self.navigationItem setHidesBackButton:editing animated:NO];
	
    if(!editing)
    {
        // Done editing - save context
        [[DataModelController theDataModelController] saveContext];
    }
}



@end
