//
//  VariableDateFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableDate.h"
#import "VariableDateFieldEditInfo.h"
#import "VariableDateFormInfoCreator.h"
#import "TableViewHelper.h"
#import "SelectableObjectTableEditViewController.h"
#import "StringValidation.h"

@implementation VariableDateFieldEditInfo


+ (VariableDateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                                        andLabel:(NSString*)label
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    
    ManagedObjectFieldInfo *fieldInfo = [[ManagedObjectFieldInfo alloc] 
                                         initWithManagedObject:obj andFieldKey:key andFieldLabel:label];
    VariableDateFieldEditInfo *fieldEditInfo = [[VariableDateFieldEditInfo alloc] initWithFieldInfo:fieldInfo];
    [fieldEditInfo autorelease];
    [fieldInfo release];
    
    return fieldEditInfo;
}

- (NSString*)detailTextLabel
{
    
//    VariableDate *varDate = [self.fieldInfo getFieldValue];
    return @"VariableDate";
}

- (UIViewController*)fieldEditController
{
    
    VariableDateFormInfoCreator *formInfoCreator = 
        [[[VariableDateFormInfoCreator alloc] initWithVariableDateFieldInfo:self.fieldInfo] autorelease];
    
    SelectableObjectTableEditViewController *viewController = 
    [[[SelectableObjectTableEditViewController alloc] initWithFormInfoCreator:formInfoCreator andAssignedField:self.fieldInfo] autorelease];

    return viewController;
    
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
