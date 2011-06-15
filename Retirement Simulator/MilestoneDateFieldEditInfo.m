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
#import "DateHelper.h"
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
    return [[[DateHelper theHelper] mediumDateFormatter]
            stringFromDate:self.milestoneDate.date];
}

- (NSString*)textLabel
{
    return self.milestoneDate.name;
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

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 45.0;
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Milestones"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
            initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Milestones"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
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
