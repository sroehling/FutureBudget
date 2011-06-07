//
//  AddObjectSectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddObjectSectionInfo.h"


@implementation AddObjectSectionInfo


@synthesize parentViewController;

#define ADD_OBJECT_BUTTON_WIDTH 50.0


- (void)addObjectButtonPressed
{
    // no-op
    assert(0); // must be overriden
}

- (UIView*)viewForSectionHeader:(CGFloat)tableWidth andEditMode:(BOOL)editing
{
    UIView *headerView = [super viewForSectionHeader:tableWidth andEditMode:editing];
    assert(headerView != nil); // must have a custom view for milestone dates
    
    if(editing)
    {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addButton.frame = CGRectMake(tableWidth-ADD_OBJECT_BUTTON_WIDTH, 0.0, 
                                              ADD_OBJECT_BUTTON_WIDTH, [self viewHeightForSection]);
        [addButton setTitle:@"Add" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addObjectButtonPressed) 
                     forControlEvents:UIControlEventTouchUpInside];
        // add button to right corner of section        
        [headerView addSubview:addButton];
    }
    return headerView;
}



- (CGFloat)sectionViewRightOffset:(BOOL)editing
{
    if(editing)
    {
        return ADD_OBJECT_BUTTON_WIDTH;
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
