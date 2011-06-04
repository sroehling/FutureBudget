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
#import "DateHelper.h"

@implementation VariableDateFieldEditInfo

#define TABLE_CELL_BLUE_TEXT_COLOR [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0]


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
    assert([self.fieldInfo fieldIsInitializedInParentObject]);
    VariableDate *varDate = [self.fieldInfo getFieldValue];
    return [[[DateHelper theHelper] mediumDateFormatter] stringFromDate:varDate.date];
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

    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        cell.detailTextLabel.textColor = TABLE_CELL_BLUE_TEXT_COLOR;
        cell.detailTextLabel.text = [self detailTextLabel];
    }
    else
    {
        // Set the text color on the label to light gray to indicate that
        // the value needs to be filled in (the same as a placeholder
        // in a text field).
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.text = @"Enter a Date";

    }
    
    return cell;
}



@end
