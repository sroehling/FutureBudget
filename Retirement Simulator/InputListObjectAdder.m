//
//  InputListObjectAdder.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputListObjectAdder.h"
#import "InputTypeSelectionViewController.h"

@implementation InputListObjectAdder

-(void)addObjectFromTableView:(UITableViewController*)parentView
{
	InputTypeSelectionViewController *inputTypeViewController = 
		[[[InputTypeSelectionViewController alloc ]initWithStyle:UITableViewStyleGrouped] autorelease];
    [parentView.navigationController pushViewController:inputTypeViewController animated:YES];

}

-(BOOL)supportsAddOutsideEditMode
{
	return TRUE;
}

@end
