//
//  DateSensitiveValueFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueFieldEditInfo.h"
#import "DateSensitiveValueFieldEditViewController.h"
#import "DateSensitiveValue.h"
#import "TableViewHelper.h"
#import "StringValidation.h"

@implementation DateSensitiveValueFieldEditInfo

@synthesize variableValueEntityName;


+ (DateSensitiveValueFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
           andLabel:(NSString*)label andEntityName:(NSString*)entityName
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    assert([StringValidation nonEmptyString:entityName]);
    
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
                                         initWithManagedObject:obj andFieldKey:key andFieldLabel:label];
    DateSensitiveValueFieldEditInfo *fieldEditInfo = [[DateSensitiveValueFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    fieldEditInfo.variableValueEntityName = entityName;
    [fieldEditInfo autorelease];
    [fieldInfo release];
    
    return fieldEditInfo;
}


- (NSString*)detailTextLabel
{
    DateSensitiveValue *dsValue = [self.fieldInfo getFieldValue];
    return [dsValue valueDescription];
}

- (UIViewController*)fieldEditController
{
    DateSensitiveValueFieldEditViewController *dsValueController = 
        [[DateSensitiveValueFieldEditViewController alloc] initWithFieldInfo:fieldInfo];
    assert(self.variableValueEntityName != nil);
    assert([self.variableValueEntityName length] > 0);
    dsValueController.variableValueEntityName = self.variableValueEntityName;
    [dsValueController autorelease];
    return dsValueController;
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
