//
//  DateSensitiveValueFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueFieldEditInfo.h"
#import "DateSensitiveValue.h"
#import "TableViewHelper.h"
#import "StringValidation.h"
#import "DateSensitiveValueFormInfoCreator.h"
#import "SelectableObjectTableEditViewController.h"
#import "ColorHelper.h"
#import "ManagedObjectFieldInfo.h"

@implementation DateSensitiveValueFieldEditInfo

@synthesize varValRuntimeInfo;
@synthesize defafaultFixedValFieldInfo;


- (id)initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo 
	andDefaultFixedValFieldInfo:(ManagedObjectFieldInfo*)theDefaultFieldInfo
      andValRuntimeInfo:(VariableValueRuntimeInfo *)theVarValRuntimeInfo
{
    self = [super initWithFieldInfo:theFieldInfo];
    if(self)
    {
        assert(theDefaultFieldInfo != nil);
        self.defafaultFixedValFieldInfo = theDefaultFieldInfo;
        
        assert(theVarValRuntimeInfo != nil);
        self.varValRuntimeInfo = theVarValRuntimeInfo;
    }
    return self;
}

- (id) initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo
{
    assert(0); // should not be called
}

- (id) init
{
    assert(0); // should not be called
}

+ (DateSensitiveValueFieldEditInfo*)createForObject:
			(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo
				andDefaultFixedValKey:(NSString*)defaultFixedValKey;
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    assert(varValRuntimeInfo != nil);
    
    ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
           initWithManagedObject:obj andFieldKey:key andFieldLabel:label] autorelease];
    
    ManagedObjectFieldInfo *defaultFixedValFieldInfo = [[[ManagedObjectFieldInfo alloc] initWithManagedObject:obj andFieldKey:defaultFixedValKey andFieldLabel:@"Value"] autorelease];
    NSLog(@"Default value for date sensitive field: %@",[defaultFixedValFieldInfo description]);
    assert([defaultFixedValFieldInfo fieldIsInitializedInParentObject]);

    DateSensitiveValueFieldEditInfo *fieldEditInfo = [[[DateSensitiveValueFieldEditInfo alloc]                                                       
         initWithFieldInfo:fieldInfo andDefaultFixedValFieldInfo:defaultFixedValFieldInfo
          andValRuntimeInfo:varValRuntimeInfo] autorelease];
     
    return fieldEditInfo;
}


- (NSString*)detailTextLabel
{
    DateSensitiveValue *dsValue = [self.fieldInfo getFieldValue];
    return [dsValue valueDescription];
}

- (UIViewController*)fieldEditController
{

    FixedValue *defaultFixedVal = (FixedValue*)[self.defafaultFixedValFieldInfo getFieldValue];
    
    DateSensitiveValueFormInfoCreator *dsvFormInfoCreator = 
    [[[DateSensitiveValueFormInfoCreator alloc] initWithVariableValueFieldInfo:self.fieldInfo 
        andDefaultFixedVal:defaultFixedVal andVarValRuntimeInfo:self.varValRuntimeInfo] autorelease];
    
    SelectableObjectTableEditViewController *dsValueController = 
            [[[SelectableObjectTableEditViewController alloc] initWithFormInfoCreator:dsvFormInfoCreator 
                  andAssignedField:self.fieldInfo] autorelease];
    
    return dsValueController;
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
    // TBD - This block of code is identical as for the variable dates ...
    // can it somehow be shared between the 2.
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
        cell.detailTextLabel.text = @"Enter a Value";
        
    }
    return cell;
}

- (void) dealloc
{
    [super dealloc];
    [varValRuntimeInfo release];
    [defafaultFixedValFieldInfo release];
}


@end
