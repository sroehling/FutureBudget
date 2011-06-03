//
//  MilestoneDateFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MilestoneDateFieldEditInfo.h"
#import "TableViewHelper.h"
#import "StringValidation.h"
#import "FormPopulator.h"
#import "MilestoneDate.h"
#import "FormInfo.h"
#import "SectionInfo.h"
#import "MilestoneDateFormPopulator.h"

@implementation MilestoneDateFieldEditInfo

@synthesize milestoneDate;

+ (MilestoneDateFieldEditInfo*)createForMilestoneDate:(MilestoneDate *)theMilestoneDate
{
    MilestoneDateFieldEditInfo *fieldEditInfo = [[[MilestoneDateFieldEditInfo alloc]initWithMilestoneDate:theMilestoneDate]autorelease];
    return fieldEditInfo;
}

- (id)initWithMilestoneDate:(MilestoneDate*)theMilestoneDate
{
    assert(theMilestoneDate != nil);
    self = [super init];
    if(self)
    {
        self.milestoneDate = theMilestoneDate;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [milestoneDate release];
}

- (NSString*)detailTextLabel
{
    return self.milestoneDate.name;
}

- (NSString*)textLabel
{
    return @"Date";
}

- (UIViewController*)fieldEditController
{
    MilestoneDateFormPopulator *formPopulator = [[[MilestoneDateFormPopulator alloc] init] autorelease];
    return [formPopulator milestoneDateEditViewController:self.milestoneDate];
}

- (BOOL)hasFieldEditController
{
    return TRUE;
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
    UITableViewCell *cell = [TableViewHelper reuseOrAllocCell:tableView];
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self textLabel];
    cell.detailTextLabel.text = [self detailTextLabel];
    return cell;
}


- (BOOL)fieldIsInitializedInParentObject
{
    return TRUE;
}

- (void)disableFieldAccess
{
    // no-op
    // TBD - should this be a no-op
}

- (NSManagedObject*) managedObject
{
    return self.milestoneDate;
}




@end
