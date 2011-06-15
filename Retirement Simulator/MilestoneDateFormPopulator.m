//
//  MilestoneDateFormPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MilestoneDateFormPopulator.h"

#import "FormPopulator.h"
#import "FormInfo.h"
#import "SectionInfo.h"
#import "TextFieldEditInfo.h"
#import "DateFieldEditInfo.h"
#import "MilestoneDate.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "StaticFormInfoCreator.h"

@implementation MilestoneDateFormPopulator

- (void)populateForMilestoneDate:(MilestoneDate*)milestoneDate
{
    self.formInfo.title = @"Milestone Date";
    
    SectionInfo *sectionInfo = [self nextSection];
    [sectionInfo addFieldEditInfo:[TextFieldEditInfo createForObject:milestoneDate 
                                                              andKey:@"name" andLabel:@"name"]];
    [sectionInfo addFieldEditInfo:[DateFieldEditInfo createForObject:milestoneDate 
                                                              andKey:@"date" andLabel:@"Date"]];

}

- (UIViewController*)milestoneDateAddViewController:(MilestoneDate*)milestoneDate
{
    [self populateForMilestoneDate:milestoneDate];
    GenericFieldBasedTableAddViewController *controller = [[[GenericFieldBasedTableAddViewController alloc]
         initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:self.formInfo] 
        andNewObject:milestoneDate] autorelease];
    controller.popDepth =1;
    return controller;
    
}

- (UIViewController*)milestoneDateEditViewController:(MilestoneDate*)milestoneDate
{
    [self populateForMilestoneDate:milestoneDate];
    UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc] initWithFormInfoCreator:[StaticFormInfoCreator createWithFormInfo:self.formInfo]] autorelease];

    return controller;
    
}



@end
