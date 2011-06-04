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

@synthesize parentViewController;

#define ADD_MILESTONE_BUTTON_WIDTH 50.0

- (void)addMilestone
{
    assert(self.parentViewController != nil);
    NSLog(@"Add milestone");
    
    MilestoneDate *newMilestoneDate = (MilestoneDate*)
        [[DataModelController theDataModelController]insertObject:@"MilestoneDate"];
    

    MilestoneDateFormPopulator *formPopulator = [[[MilestoneDateFormPopulator alloc] init] autorelease];
    UIViewController *controller =  [formPopulator milestoneDateAddViewController:newMilestoneDate];
    
    [self.parentViewController.navigationController pushViewController:controller animated:YES];
    

}

- (UIView*)viewForSectionHeader:(CGFloat)tableWidth andEditMode:(BOOL)editing
{
    UIView *headerView = [super viewForSectionHeader:tableWidth andEditMode:editing];
    assert(headerView != nil); // must have a custom view for milestone dates

    if(editing)
    {
        UIButton *addMilestoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addMilestoneButton.frame = CGRectMake(tableWidth-ADD_MILESTONE_BUTTON_WIDTH, 0.0, 
            ADD_MILESTONE_BUTTON_WIDTH, [self viewHeightForSection]);
        [addMilestoneButton setTitle:@"Add" forState:UIControlStateNormal];
        [addMilestoneButton addTarget:self action:@selector(addMilestone) 
             forControlEvents:UIControlEventTouchUpInside];
        // add button to right corner of section        
        [headerView addSubview:addMilestoneButton];
    }
    return headerView;
}
     
    

- (CGFloat)sectionViewRightOffset:(BOOL)editing
{
    if(editing)
    {
        return ADD_MILESTONE_BUTTON_WIDTH;
    }
    else
    {
        return 0.0;
    }
}

- (void) dealloc
{
    [super dealloc];
}


@end
