//
//  RepeatFrequencyFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RepeatFrequencyFieldEditInfo.h"
#import "RepeatFrequencyEditViewController.h"
#import "EventRepeatFrequency.h"
#import "TableViewHelper.h"
#import "StringValidation.h"

@implementation RepeatFrequencyFieldEditInfo

+ (RepeatFrequencyFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                             andLabel:(NSString*)label
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
                                         initWithManagedObject:obj andFieldKey:key andFieldLabel:label];
    RepeatFrequencyFieldEditInfo *fieldEditInfo = [[RepeatFrequencyFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [fieldEditInfo autorelease];
    [fieldInfo release];
    
    return fieldEditInfo;
}

- (NSString*)detailTextLabel
{
    
    EventRepeatFrequency *repeatFrequency = [self.fieldInfo getFieldValue];
    return [repeatFrequency description];
}

- (UIViewController*)fieldEditController
{
    
    
    RepeatFrequencyEditViewController *repeatController = 
    [[RepeatFrequencyEditViewController alloc] initWithFieldInfo:fieldInfo];
    [repeatController autorelease];
    return repeatController;

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

@end
