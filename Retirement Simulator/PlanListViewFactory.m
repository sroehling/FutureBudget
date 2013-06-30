//
//  PlanListViewFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/27/13.
//
//

#import "PlanListViewFactory.h"
#import "GenericTableViewFactory.h"
#import "PlanListViewController.h"

@implementation PlanListViewFactory

-(UIViewController*)createTableView:(FormContext*)parentContext
{
	return [[[PlanListViewController alloc] init] autorelease];
}


@end
