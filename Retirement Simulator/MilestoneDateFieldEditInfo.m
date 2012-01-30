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
#import "DataModelController.h"

@implementation MilestoneDateFieldEditInfo

@synthesize milestoneDate;
@synthesize milestoneCell;
@synthesize varDateRuntimeInfo;
@synthesize parentController;

- (void) configureCell
{
	self.milestoneCell.caption.text = [self textLabel];
    self.milestoneCell.valueDescription.text = [self detailTextLabel];
}

- (id)initWithMilestoneDate:(MilestoneDate*)theMilestoneDate 
	  andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
	  andParentController:(UIViewController *)theParentController
{
    assert(theMilestoneDate != nil);
    self = [super init];
    if(self)
    {
        self.milestoneDate = theMilestoneDate;
		
		self.varDateRuntimeInfo = theVarDateRuntimeInfo;
		
		assert(theParentController != nil);
		self.parentController = theParentController;
		
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
	[varDateRuntimeInfo release];
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
    MilestoneDateFormPopulator *formPopulator = [[[MilestoneDateFormPopulator alloc] 
				initWithRuntimeInfo:self.varDateRuntimeInfo
				andParentController:self.parentController] autorelease];
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

-(BOOL)supportsDelete
{
	// TODO - Need to ensure the milestone date is not referred to by other inputs before
	// allowing it to be deleted.
	return [self.milestoneDate supportsDeletion];
}


- (void)deleteObject
{
	assert(self.milestoneDate != nil);
	[[DataModelController theDataModelController] deleteObject:self.milestoneDate];
	self.milestoneDate = nil;
}




@end
