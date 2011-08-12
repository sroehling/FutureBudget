//
//  RelativeEndDateFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RelativeEndDateFieldEditInfo.h"
#import "RelativeEndDate.h"
#import "ValueSubtitleTableCell.h"
#import "RelativeDatePickerViewController.h"
#import "DateHelper.h"
#import "LocalizationHelper.h"

@implementation RelativeEndDateFieldEditInfo

@synthesize relEndDateFieldInfo;
@synthesize relEndDateCell;

- (id)initWithRelativeEndDateFieldInfo:(FieldInfo*)theRelEndDateFieldInfo
{
    self = [super init];
    if(self)
    {
		assert(theRelEndDateFieldInfo != nil);
        self.relEndDateFieldInfo = theRelEndDateFieldInfo;
		
		self.relEndDateCell = 
		[[[ValueSubtitleTableCell alloc] initWithFrame:CGRectZero] autorelease];
		self.relEndDateCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
		self.relEndDateCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return self;
}


- (id) init
{
	assert(0); // must call init above
	return nil;
}


- (void) dealloc
{
    [super dealloc];
	[relEndDateFieldInfo release];
	[relEndDateCell release];
}

- (void)configureRelEndDateCell
{
	self.relEndDateCell.caption.text = [self textLabel];	
	self.relEndDateCell.valueDescription.text = [self detailTextLabel];
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	[self configureRelEndDateCell];
	return [self.relEndDateCell cellHeight];
}


- (NSString*)detailTextLabel
{
	RelativeEndDate *relEndDate = (RelativeEndDate *)[self.relEndDateFieldInfo fieldObject];
    return [relEndDate inlineDescription:[[DateHelper theHelper] mediumDateFormatter]];;
}

- (NSString*)textLabel
{
    return LOCALIZED_STR(@"RELATIVE_END_DATE_LABEL");
}

- (UIViewController*)fieldEditController
{
    return [[[RelativeDatePickerViewController alloc] 
		initWithRelativeEndDateFieldInfo:self.relEndDateFieldInfo] autorelease];
}

- (BOOL)hasFieldEditController
{
    return TRUE;
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
    [self configureRelEndDateCell];
    return self.relEndDateCell;
}


- (BOOL)fieldIsInitializedInParentObject
{
    return FALSE;
}

- (void)disableFieldAccess
{
    // no-op
    // TBD - should this be a no-op
}

- (NSManagedObject*) managedObject
{
    return [self.relEndDateFieldInfo fieldObject];
}


@end
