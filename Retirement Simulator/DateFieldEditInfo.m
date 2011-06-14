//
//  DateFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateFieldEditInfo.h"
#import "DateFieldEditViewController.h"
#import "TableViewHelper.h"
#import "StringValidation.h"
#import "DateHelper.h"


@implementation DateFieldEditInfo


+ (DateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                             andLabel:(NSString*)label
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
                                         initWithManagedObject:obj andFieldKey:key andFieldLabel:label];
    DateFieldEditInfo *fieldEditInfo = [[DateFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [fieldEditInfo autorelease];
    [fieldInfo release];
    
    return fieldEditInfo;
}


- (NSString*)detailTextLabel
{
    return [[[DateHelper theHelper] mediumDateFormatter]
        stringFromDate:[self.fieldInfo getFieldValue]];
}

- (UIViewController*)fieldEditController
{
    DateFieldEditViewController *dateController = 
        [[DateFieldEditViewController alloc] initWithNibName:@"DateFieldEditViewController"
                                                andFieldInfo:fieldInfo];
    [dateController autorelease];
    return dateController;

}


- (void)dealloc {
    [super dealloc];
}

- (BOOL)hasFieldEditController
{
    return TRUE;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 40.0;
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
    
    UITableViewCell *cell = [TableViewHelper reuseOrAllocCell:tableView];
    
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self textLabel];
    
    
    // Only try to initialize the text in the field if the field's
    // value has been initialized in the parent object. If it hasn't,
    // the text field will be left blank and the placeholder value
    // will be shown.
    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        cell.detailTextLabel.text = [self detailTextLabel];
    }
    else
    {
        cell.detailTextLabel.text = @"Enter a Date";
    }

    
    return cell;
}

@end
