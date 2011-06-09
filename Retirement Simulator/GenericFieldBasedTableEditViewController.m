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
			[[DataModelController theDataModelController] saveContext];
		}
	}
	else
	{
		[super setEditing:editing animated:animated];
		
		[self.navigationItem setHidesBackButton:editing animated:NO];
		
	}	
 }



@end
