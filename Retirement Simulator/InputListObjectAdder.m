//
//  InputListObjectAdder.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputListObjectAdder.h"
#import "InputTypeSelectionViewController.h"
#import "FormContext.h"

@implementation InputListObjectAdder

-(void)addObjectFromTableView:(FormContext*)parentContext
{
	InputTypeSelectionViewController *inputTypeViewController = 
		[[[InputTypeSelectionViewController alloc ]initWithStyle:UITableViewStyleGrouped] autorelease];
    [parentContext.parentController.navigationController pushViewController:inputTypeViewController animated:YES];

}

-(BOOL)supportsAddOutsideEditMode
{
	return TRUE;
}

@end
