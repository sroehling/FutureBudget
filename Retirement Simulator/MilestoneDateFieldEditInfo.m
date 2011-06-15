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
#import "ValueSubtitleTableCell.h"

@implementation MilestoneDateFieldEditInfo

@synthesize milestoneDate;
@synthesize milestoneCell;

- (void) configureCell
{
	self.milestoneCell.caption.text = [self textLabel];
    self.milestoneCell.valueDescription.text = [self detailTextLabel];
}

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
		
		self.milestoneCell = [[[ValueSubtitleTableCell alloc] init] autorelease];
		[self configureCell];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [milestoneDate release];
	[milestoneCell release];
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
	return [self.milestoneCell cellHeight];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
    [self configureCell];
    return self.milestoneCell;
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
