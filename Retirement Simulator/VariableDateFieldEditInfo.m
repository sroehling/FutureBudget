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
#import "ValueSubtitleTableCell.h"

@implementation VariableDateFieldEditInfo

@synthesize defaultValFieldInfo;
@synthesize dateCell;

- (void)configureDateCell
{
	self.dateCell.caption.text = [self textLabel];
	
    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        self.dateCell.valueDescription.textColor = [ColorHelper blueTableTextColor];
        self.dateCell.valueDescription.text = [self detailTextLabel];
		VariableDate *theDate = (VariableDate*)[self.fieldInfo getFieldValue];
		self.dateCell.valueSubtitle.text = [theDate dateLabel];
    }
    else
    {
        // Set the text color on the label to light gray to indicate that
        // the value needs to be filled in (the same as a placeholder
        // in a text field).
        self.dateCell.valueDescription.textColor = [ColorHelper promptTextColor];
        self.dateCell.valueDescription.text = @"Enter a Date";
		self.dateCell.valueSubtitle.text = @"";
    }
	
}

- (id) initWithFieldInfo:(ManagedObjectFieldInfo*)theFieldInfo andDefaultValFieldInfo:
        (ManagedObjectFieldInfo*)theDefaultFieldInfo
{
    self = [super initWithFieldInfo:theFieldInfo];
    if(self)
    {
        assert(theDefaultFieldInfo!=nil);
        assert([theDefaultFieldInfo fieldIsInitializedInParentObject]);
        self.defaultValFieldInfo = theDefaultFieldInfo;

		self.dateCell = [[[ValueSubtitleTableCell alloc] init] autorelease];
		self.dateCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.dateCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[self configureDateCell];
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


- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return [self.dateCell cellHeight];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
	[self configureDateCell];
    
    return self.dateCell;
}



@end
