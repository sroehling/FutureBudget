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
#import "ManagedObjectFieldInfo.h"
#import "ColorHelper.h"

@implementation VariableDateFieldEditInfo


@synthesize defaultValFieldInfo;


- (id) initWithFieldInfo:(ManagedObjectFieldInfo*)theFieldInfo andDefaultValFieldInfo:
        (ManagedObjectFieldInfo*)theDefaultFieldInfo
{
    self = [super initWithFieldInfo:theFieldInfo];
    if(self)
    {
        assert(theDefaultFieldInfo!=nil);
        assert([theDefaultFieldInfo fieldIsInitializedInParentObject]);
        self.defaultValFieldInfo = theDefaultFieldInfo;
    }
    return self;
}

- (id) initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo
{
    assert(0); // should not call this version of init
}


+ (VariableDateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key
                                     andLabel:(NSString*)label andDefaultValueKey:(NSString*)defaultValKey
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    assert([StringValidation nonEmptyString:defaultValKey]);
    
    ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
                                         initWithManagedObject:obj andFieldKey:key andFieldLabel:label] autorelease];
 
    
    ManagedObjectFieldInfo *defaultValFieldInfo = [[[ManagedObjectFieldInfo alloc] 
                                          initWithManagedObject:obj 
                        andFieldKey:defaultValKey andFieldLabel:label] autorelease];

    
    VariableDateFieldEditInfo *fieldEditInfo = [[[VariableDateFieldEditInfo alloc] 
        initWithFieldInfo:fieldInfo andDefaultValFieldInfo:defaultValFieldInfo] autorelease];

    
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
        [[[VariableDateFormInfoCreator alloc] initWithVariableDateFieldInfo:self.fieldInfo 
          andDefaultValFieldInfo:self.defaultValFieldInfo] autorelease];
    
    SelectableObjectTableEditViewController *viewController = 
    [[[SelectableObjectTableEditViewController alloc] initWithFormInfoCreator:formInfoCreator 
            andAssignedField:self.fieldInfo] autorelease];

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
        cell.detailTextLabel.textColor = [ColorHelper blueTableTextColor];
        cell.detailTextLabel.text = [self detailTextLabel];
    }
    else
    {
        // Set the text color on the label to light gray to indicate that
        // the value needs to be filled in (the same as a placeholder
        // in a text field).
        cell.detailTextLabel.textColor = [ColorHelper promptTextColor];
        cell.detailTextLabel.text = @"Enter a Date";

    }
    
    return cell;
}



@end
