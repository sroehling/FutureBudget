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
#import "DateHelper.h"
#import "LocalizationHelper.h"
#import "SimDateRuntimeInfo.h"
#import "DurationFieldEditViewController.h"
#import "FormContext.h"

@implementation RelativeEndDateFieldEditInfo

@synthesize relEndDateFieldInfo;
@synthesize relEndDateCell;
@synthesize simDateRuntimeInfo;
@synthesize dateHelper;

- (void) dealloc
{
	[relEndDateFieldInfo release];
	[relEndDateCell release];
	[simDateRuntimeInfo release];
    [dateHelper release];
    
    [super dealloc];
}


- (id)initWithRelativeEndDateFieldInfo:(FieldInfo*)theRelEndDateFieldInfo
	andSimDateRuntimeInfo:(SimDateRuntimeInfo*)theRuntimeInfo
{
    self = [super init];
    if(self)
    {
		assert(theRelEndDateFieldInfo != nil);
        self.relEndDateFieldInfo = theRelEndDateFieldInfo;
		assert(theRuntimeInfo != nil);
		self.simDateRuntimeInfo = theRuntimeInfo;
		
		self.relEndDateCell = 
		[[[ValueSubtitleTableCell alloc] initWithFrame:CGRectZero] autorelease];
		self.relEndDateCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
		self.relEndDateCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.dateHelper = [[[DateHelper alloc] init] autorelease];

    }
    return self;
}


- (id) init
{
	assert(0); // must call init above
	return nil;
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
    return [relEndDate inlineDescription:self.dateHelper.mediumDateFormatter];
}

- (NSString*)textLabel
{
    return self.simDateRuntimeInfo.relEndDateFieldLabel;
}

- (UIViewController*)fieldEditController:(FormContext*)parentContext
{
    DurationFieldEditViewController *durationController = 
        [[[DurationFieldEditViewController alloc] initWithDurationFieldInfo:self.relEndDateFieldInfo] autorelease];
    return durationController;
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


- (NSManagedObject*) managedObject
{
    return [self.relEndDateFieldInfo fieldObject];
}


- (BOOL)isSelected
{
	assert(self.relEndDateFieldInfo != nil);
	return self.relEndDateFieldInfo.isSelectedForSelectableObjectTableView;
}

- (void)updateSelection:(BOOL)isSelected
{
	assert(self.relEndDateFieldInfo != nil);
	self.relEndDateFieldInfo.isSelectedForSelectableObjectTableView = isSelected;
}

@end
