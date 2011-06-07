//
//  MilestoneDateSectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MilestoneDateSectionInfo.h"
#import "MilestoneDateFormPopulator.h"
#import "DataModelController.h"
#import "MilestoneDate.h"


@implementation MilestoneDateSectionInfo

- (void)addObjectButtonPressed
{
    assert(self.parentViewController != nil);
    NSLog(@"Add milestone");
    
    MilestoneDate *newMilestoneDate = (MilestoneDate*)
        [[DataModelController theDataModelController]insertObject:@"MilestoneDate"];
    

    MilestoneDateFormPopulator *formPopulator = [[[MilestoneDateFormPopulator alloc] init] autorelease];
    UIViewController *controller =  [formPopulator milestoneDateAddViewController:newMilestoneDate];
    
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
}



@end
