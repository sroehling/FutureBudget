//
//  TableViewHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableViewHelper.h"


@implementation TableViewHelper



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
