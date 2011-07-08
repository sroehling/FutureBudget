//
//  VariableDateFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimDate.h"
#import "SimDateFieldEditInfo.h"
#import "SimDateFormInfoCreator.h"
#import "TableViewHelper.h"
#import "SelectableObjectTableEditViewController.h"
#import "MultiScenarioInputValueFieldInfo.h"
#import "StringValidation.h"
#import "DateHelper.h"
#import "ManagedObjectFieldInfo.h"
#import "ColorHelper.h"
#import "ValueSubtitleTableCell.h"
#import "LocalizationHelper.h"
#import "SimDateValueFormatter.h"
#import "DataModelController.h"
#import "SharedAppValues.h"
#import "Scenario.h"
#import "MultiScenarioFixedDateFieldInfo.h"
#import "MultiScenarioInputValue.h"

@implementation SimDateFieldEditInfo

@synthesize defaultValFieldInfo;
@synthesize dateCell;
@synthesize varDateRuntimeInfo;

- (void)configureDateCell
{
	self.dateCell.caption.text = [self textLabel];
	
    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        self.dateCell.valueDescription.textColor = [ColorHelper blueTableTextColor];
        self.dateCell.valueDescription.text = [self detailTextLabel];
		SimDate *theDate = (SimDate*)[self.fieldInfo getFieldValue];
		self.dateCell.valueSubtitle.text = [theDate dateLabel];
    }
    else
    {
        // Set the text color on the label to light gray to indicate that
        // the value needs to be filled in (the same as a placeholder
        // in a text field).
        self.dateCell.valueDescription.textColor = [ColorHelper promptTextColor];
        self.dateCell.valueDescription.text = LOCALIZED_STR(@"VARIABLE_DATE_DATE_ENTRY_PROMPT");
		self.dateCell.valueSubtitle.text = @"";
    }
	
}

- (id) initWithFieldInfo:(ManagedObjectFieldInfo*)theFieldInfo andDefaultValFieldInfo:
        (FieldInfo*)theDefaultFieldInfo 
		andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
		andShowNeverEnding:(bool)doShowNeverEnding
{
    self = [super initWithFieldInfo:theFieldInfo];
    if(self)
    {
        assert(theDefaultFieldInfo!=nil);
        assert([theDefaultFieldInfo fieldIsInitializedInParentObject]);
        self.defaultValFieldInfo = theDefaultFieldInfo;
		
		self.varDateRuntimeInfo = theVarDateRuntimeInfo;
		showNeverEnding = doShowNeverEnding;

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

+ (SimDateFieldEditInfo*)createForMultiScenarioVal:(Scenario*)scenario 
	andObject:(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label
	andDefaultValue:(MultiScenarioInputValue*)defaultVal 
	andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo 
	andShowNeverEnding:(bool)doShowNeverEnding
{
    assert(obj != nil);
	assert(defaultVal != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    
	
	NSString *variableDatePlaceholder = LOCALIZED_STR(@"VARIABLE_DATE_PLACEHOLDER");
	
	
	MultiScenarioInputValueFieldInfo *fieldInfo = [[[MultiScenarioInputValueFieldInfo alloc]
													initWithScenario:scenario andManagedObject:obj andFieldKey:key 
													andFieldLabel:label andFieldPlaceholder:variableDatePlaceholder] autorelease];
	
    
	MultiScenarioFixedDateFieldInfo *defaultValFieldInfo = 
		[[[MultiScenarioFixedDateFieldInfo alloc] initWithFieldLabel:label andFieldPlaceholder:variableDatePlaceholder andScenario:scenario andInputVal:defaultVal] autorelease];	
    
    SimDateFieldEditInfo *fieldEditInfo = [[[SimDateFieldEditInfo alloc] 
											initWithFieldInfo:fieldInfo andDefaultValFieldInfo:defaultValFieldInfo andVarDateRuntimeInfo:theVarDateRuntimeInfo andShowNeverEnding:doShowNeverEnding] autorelease];
	
    
    return fieldEditInfo;
}



+ (SimDateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label andDefaultValueKey:(NSString*)defaultValKey andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo andShowNeverEnding:(bool)doShowNeverEnding
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
    assert([StringValidation nonEmptyString:defaultValKey]);
    
	
	NSString *variableDatePlaceholder = LOCALIZED_STR(@"VARIABLE_DATE_PLACEHOLDER");
	
    ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
										  initWithManagedObject:obj andFieldKey:key 
										  andFieldLabel:label
										  andFieldPlaceholder:variableDatePlaceholder] autorelease];
    
    ManagedObjectFieldInfo *defaultValFieldInfo = [[[ManagedObjectFieldInfo alloc] 
                                          initWithManagedObject:obj 
                        andFieldKey:defaultValKey andFieldLabel:label
						andFieldPlaceholder:variableDatePlaceholder] autorelease];

    
    SimDateFieldEditInfo *fieldEditInfo = [[[SimDateFieldEditInfo alloc] 
        initWithFieldInfo:fieldInfo andDefaultValFieldInfo:defaultValFieldInfo andVarDateRuntimeInfo:theVarDateRuntimeInfo andShowNeverEnding:doShowNeverEnding] autorelease];

    
    return fieldEditInfo;
}



- (NSString*)detailTextLabel
{
    assert([self.fieldInfo fieldIsInitializedInParentObject]);
	
	SimDateValueFormatter *valFormatter = [[[SimDateValueFormatter alloc] init] autorelease];
    SimDate *simDate = [self.fieldInfo getFieldValue];
    return [valFormatter formatSimDate:simDate];
}

- (UIViewController*)fieldEditController
{
    
    SimDateFormInfoCreator *formInfoCreator = 
        [[[SimDateFormInfoCreator alloc] initWithVariableDateFieldInfo:self.fieldInfo 
          andDefaultValFieldInfo:self.defaultValFieldInfo 
		  andVarDateRuntimeInfo:self.varDateRuntimeInfo
		  andDoShowNeverEnding:showNeverEnding] autorelease];
    
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

-(void)dealloc
{
	[super dealloc];
	[varDateRuntimeInfo release];
	[defaultValFieldInfo release];
	[dateCell release];
}


@end
