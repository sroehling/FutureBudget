//
//  TableViewHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewHelper.h"


@implementation TableViewHelper


+(UITableViewCell*)reuseOrAllocCell:(UITableView*)tableView
{
    assert(tableView != nil);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    return cell;
}


+(void)popControllerByDepth:(UIViewController*)currentViewController popDepth:(NSInteger)popDepth
{
    assert(currentViewController != nil);
    assert(popDepth >= 1);
    
    NSArray*allViewControllers = currentViewController.navigationController.viewControllers;
    NSInteger currentDepthIndex =[allViewControllers count]-1;
    assert((currentDepthIndex - popDepth) >=0);
    UIViewController *controllerAtPopToDepth = [allViewControllers 
                                                objectAtIndex:(currentDepthIndex-popDepth)];
    assert(controllerAtPopToDepth != nil);
    [currentViewController.navigationController 
        popToViewController:controllerAtPopToDepth animated: YES];
    
}


@end
