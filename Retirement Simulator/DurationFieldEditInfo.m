//
//  DurationFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DurationFieldEditInfo.h"
#import "TableViewHelper.h"
#import "StringValidation.h"
#import "DateHelper.h"
#import "ManagedObjectFieldInfo.h"
#import "ValueSubtitleTableCell.h"
#import "LocalizationHelper.h"
#import "DurationFieldEditViewController.h"
#import "DurationInfo.h"


@implementation DurationFieldEditInfo


- (NSString*)detailTextLabel
{
	NSNumber *durationVal = [self.fieldInfo getFieldValue];
	if(durationVal != nil)
	{
		DurationInfo *durationInfo = 
			[[[DurationInfo alloc] initWithTotalMonths:durationVal] autorelease];
		return [durationInfo yearsAndMonthsFormatted];
	}
	else
	{
		return @"";
	}
}

- (UIViewController*)fieldEditController
{
    DurationFieldEditViewController *durationController = 
        [[[DurationFieldEditViewController alloc] initWithDurationFieldInfo:fieldInfo] autorelease];
    return durationController;

}

- (BOOL)hasFieldEditController
{
    return TRUE;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 30.0;
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
    
	ValueSubtitleTableCell *cell = [[[ValueSubtitleTableCell alloc] init] autorelease];
	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.caption.text = [self textLabel];
    
    
    // Only try to initialize the text in the field if the field's
    // value has been initialized in the parent object. If it hasn't,
    // the text field will be left blank and the placeholder value
    // will be shown.
    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        cell.valueDescription.text = [self detailTextLabel];
    }
    else
    {
        cell.valueDescription.text = self.fieldInfo.fieldPlaceholder;
    }

    
    return cell;
}



- (void)dealloc {
    [super dealloc];
}

@end
