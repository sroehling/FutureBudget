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
#import "ValueSubtitleTableCell.h"
#import "LocalizationHelper.h"
#import "MultiScenarioInputValueFieldInfo.h"
#import "MultiScenarioInputValue.h"
#import "MultiScenarioFixedValueFieldInfo.h"

@implementation DateSensitiveValueFieldEditInfo

@synthesize varValRuntimeInfo;
@synthesize defaultFixedValFieldInfo;
@synthesize valueCell;

- (void) configureValueCell
{
	self.valueCell.caption.text = self.varValRuntimeInfo.valueTypeTitle;
    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        self.valueCell.valueDescription.textColor = [ColorHelper blueTableTextColor];
        self.valueCell.valueDescription.text = [self detailTextLabel];
		DateSensitiveValue *theValue = (DateSensitiveValue*)[self.fieldInfo getFieldValue];
		self.valueCell.valueSubtitle.text = [theValue valueSubtitle:self.varValRuntimeInfo];
    }
    else
    {
        // Set the text color on the label to light gray to indicate that
        // the value needs to be filled in (the same as a placeholder
        // in a text field).
        self.valueCell.valueDescription.textColor = [ColorHelper promptTextColor];
        self.valueCell.valueDescription.text = LOCALIZED_STR(self.varValRuntimeInfo.valuePromptKey);
        self.valueCell.valueSubtitle.text = @"";
    }
	
}

- (id)initWithFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo 
	andDefaultFixedValFieldInfo:(ManagedObjectFieldInfo*)theDefaultFieldInfo
      andValRuntimeInfo:(VariableValueRuntimeInfo *)theVarValRuntimeInfo
{
    self = [super initWithFieldInfo:theFieldInfo];
    if(self)
    {
        assert(theDefaultFieldInfo != nil);
        self.defaultFixedValFieldInfo = theDefaultFieldInfo;
        
        assert(theVarValRuntimeInfo != nil);
        self.varValRuntimeInfo = theVarValRuntimeInfo;
		
		self.valueCell = [[[ValueSubtitleTableCell alloc] init] autorelease];
		self.valueCell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.valueCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		[self configureValueCell];
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

+ (DateSensitiveValueFieldEditInfo*)createForScenario:(Scenario*)theScenario andObject:
			(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo
				andDefaultFixedVal:(MultiScenarioInputValue*)defaultFixedVal;
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    assert(varValRuntimeInfo != nil);
    
	NSString *dsvValuePlaceholder = 
	[NSString stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VALUE_PLACEHOLDER"),
	 LOCALIZED_STR(varValRuntimeInfo.valueTitleKey)];	   

	
	MultiScenarioInputValueFieldInfo *fieldInfo = [[[MultiScenarioInputValueFieldInfo alloc]
			initWithScenario:theScenario andManagedObject:obj andFieldKey:key 
			andFieldLabel:label andFieldPlaceholder:dsvValuePlaceholder] autorelease];
	   
    MultiScenarioFixedValueFieldInfo *defaultFixedValFieldInfo =
		[[[MultiScenarioFixedValueFieldInfo alloc]initWithFieldLabel:label 
		andFieldPlaceholder:dsvValuePlaceholder andScenario:theScenario andInputVal:defaultFixedVal]autorelease];
    assert([defaultFixedValFieldInfo fieldIsInitializedInParentObject]);

    DateSensitiveValueFieldEditInfo *fieldEditInfo = [[[DateSensitiveValueFieldEditInfo alloc]                                                       
         initWithFieldInfo:fieldInfo andDefaultFixedValFieldInfo:defaultFixedValFieldInfo
          andValRuntimeInfo:varValRuntimeInfo] autorelease];
     
    return fieldEditInfo;
}

+ (DateSensitiveValueFieldEditInfo*)createForObject:
			(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label 
			andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo
				andDefaultFixedValKey:(NSString*)defaultFixedValKey;
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    assert(varValRuntimeInfo != nil);
    
	NSString *dsvValuePlaceholder = 
	[NSString stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VALUE_PLACEHOLDER"),
	 LOCALIZED_STR(varValRuntimeInfo.valueTitleKey)];	   

	
    ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
           initWithManagedObject:obj andFieldKey:key andFieldLabel:label
		   andFieldPlaceholder:dsvValuePlaceholder] autorelease];
		   
    
	
	
    ManagedObjectFieldInfo *defaultFixedValFieldInfo = [[[ManagedObjectFieldInfo alloc] initWithManagedObject:obj andFieldKey:defaultFixedValKey andFieldLabel:label
				andFieldPlaceholder:dsvValuePlaceholder] autorelease];
    assert([defaultFixedValFieldInfo fieldIsInitializedInParentObject]);

    DateSensitiveValueFieldEditInfo *fieldEditInfo = [[[DateSensitiveValueFieldEditInfo alloc]                                                       
         initWithFieldInfo:fieldInfo andDefaultFixedValFieldInfo:defaultFixedValFieldInfo
          andValRuntimeInfo:varValRuntimeInfo] autorelease];
     
    return fieldEditInfo;
}


- (NSString*)detailTextLabel
{
    DateSensitiveValue *dsValue = [self.fieldInfo getFieldValue];
    return [dsValue valueDescription:self.varValRuntimeInfo];
}

- (UIViewController*)fieldEditController
{    
    DateSensitiveValueFormInfoCreator *dsvFormInfoCreator = 
    [[[DateSensitiveValueFormInfoCreator alloc] initWithVariableValueFieldInfo:self.fieldInfo 
        andDefaultValFieldInfo:self.defaultFixedValFieldInfo 
		andVarValRuntimeInfo:self.varValRuntimeInfo] autorelease];
    
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
	return [self.valueCell cellHeight];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
	[self configureValueCell];
    return self.valueCell;
}

- (void) dealloc
{
    [super dealloc];
    [varValRuntimeInfo release];
    [defaultFixedValFieldInfo release];
	[valueCell release];
}


@end
