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
#import "SimDateSubtitleFormatter.h"
#import "FixedDate.h"
#import "MultiScenarioInputValue.h"
#import "SingleScenarioRelativeEndDateFieldInfo.h"
#import "MultiScenarioRelativeEndDateFieldInfo.h"

@implementation SimDateFieldEditInfo

@synthesize defaultValFieldInfo;
@synthesize dateCell;
@synthesize varDateRuntimeInfo;
@synthesize defaultRelEndDateFieldInfo;
@synthesize subtitleFormatter;

- (void)configureDateCell
{
	self.dateCell.caption.text = [self textLabel];
	
    if([self.fieldInfo fieldIsInitializedInParentObject])
    {
        self.dateCell.valueDescription.textColor = [ColorHelper blueTableTextColor];
        self.dateCell.valueDescription.text = [self detailTextLabel];
		SimDate *theDate = (SimDate*)[self.fieldInfo getFieldValue];
		self.dateCell.valueSubtitle.text = [self.subtitleFormatter formatSimDate:theDate];
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
		andShowEndDates:(bool)doShowEndDates
		andDefaultRelEndDateFieldInfo:(FieldInfo*)theDefaultRelEndDateFieldInfo
{
    self = [super initWithFieldInfo:theFieldInfo];
    if(self)
    {
        assert(theDefaultFieldInfo!=nil);
        assert([theDefaultFieldInfo fieldIsInitializedInParentObject]);
        self.defaultValFieldInfo = theDefaultFieldInfo;
		
		self.varDateRuntimeInfo = theVarDateRuntimeInfo;
		showEndDates = doShowEndDates;
		
		self.subtitleFormatter = [[[SimDateSubtitleFormatter alloc]initWithSimDateRuntimeInfo:self.varDateRuntimeInfo] autorelease];
		
		if(showEndDates)
		{
			assert(theDefaultRelEndDateFieldInfo != nil);
		}
		self.defaultRelEndDateFieldInfo = theDefaultRelEndDateFieldInfo;

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

// TODO - Add support for fixed relative end date
+ (SimDateFieldEditInfo*)createForMultiScenarioVal:(Scenario*)scenario 
	andObject:(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label
	andDefaultValue:(MultiScenarioInputValue*)defaultVal 
	andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo 
	andShowEndDates:(bool)doShowEndDates
	andDefaultRelEndDate:(MultiScenarioInputValue*)defaultRelEndDate
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

	MultiScenarioRelativeEndDateFieldInfo *defaultRelEndDateFieldInfo = nil;	
	if(doShowEndDates)
	{
		assert(defaultRelEndDate != nil);
		defaultRelEndDateFieldInfo = 
			[[[MultiScenarioRelativeEndDateFieldInfo alloc] initWithFieldLabel:label 
				andFieldPlaceholder:variableDatePlaceholder andScenario:scenario andInputVal:defaultRelEndDate] autorelease];	
		
	}
    
    SimDateFieldEditInfo *fieldEditInfo = [[[SimDateFieldEditInfo alloc] 
											initWithFieldInfo:fieldInfo andDefaultValFieldInfo:defaultValFieldInfo andVarDateRuntimeInfo:theVarDateRuntimeInfo andShowEndDates:doShowEndDates andDefaultRelEndDateFieldInfo:defaultRelEndDateFieldInfo] autorelease];
	
    
    return fieldEditInfo;
}



+ (SimDateFieldEditInfo*)createForObject:(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label andDefaultFixedDate:(FixedDate*)defaultFixedDate andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo 
	andShowEndDates:(bool)doShowEndDates
	andDefaultRelEndDateKey:(NSString*)defaultRelEndDateKey
{
    assert(obj != nil);
    assert([StringValidation nonEmptyString:key]);
    assert([StringValidation nonEmptyString:label]);
	assert(defaultFixedDate != nil);
   
	
	NSString *variableDatePlaceholder = LOCALIZED_STR(@"VARIABLE_DATE_PLACEHOLDER");
	
	
    ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
										  initWithManagedObject:obj andFieldKey:key 
										  andFieldLabel:label
										  andFieldPlaceholder:variableDatePlaceholder] autorelease];
    
    ManagedObjectFieldInfo *defaultValFieldInfo = [[[ManagedObjectFieldInfo alloc] 
                                          initWithManagedObject:defaultFixedDate 
                        andFieldKey:SIM_DATE_DATE_KEY andFieldLabel:label
						andFieldPlaceholder:variableDatePlaceholder] autorelease];


	ManagedObjectFieldInfo *defaultRelEndDateFieldInfo = nil;
	if(doShowEndDates)
	{
		
		assert([StringValidation nonEmptyString:defaultRelEndDateKey]);
		defaultRelEndDateFieldInfo = [[[SingleScenarioRelativeEndDateFieldInfo alloc] 
                                          initWithManagedObject:obj 
                        andFieldKey:defaultRelEndDateKey andFieldLabel:label
						andFieldPlaceholder:variableDatePlaceholder] autorelease];
		
	}

    
    SimDateFieldEditInfo *fieldEditInfo = [[[SimDateFieldEditInfo alloc] 
        initWithFieldInfo:fieldInfo andDefaultValFieldInfo:defaultValFieldInfo andVarDateRuntimeInfo:theVarDateRuntimeInfo 
		andShowEndDates:doShowEndDates
		andDefaultRelEndDateFieldInfo:defaultRelEndDateFieldInfo] autorelease];

    
    return fieldEditInfo;
}



- (NSString*)detailTextLabel
{
    assert([self.fieldInfo fieldIsInitializedInParentObject]);
	
	SimDateValueFormatter *valFormatter = [[[SimDateValueFormatter alloc] initWithSimDateRuntimeInfo:self.varDateRuntimeInfo] autorelease];
    SimDate *simDate = [self.fieldInfo getFieldValue];
	// TODO - need to pass start date to val formatter, so that RelativeEndDatescan display an actual
	// end date, as opposed to just a label like "1 occurrence".
    return [valFormatter formatSimDate:simDate];
}

- (UIViewController*)fieldEditController
{
    
    SimDateFormInfoCreator *formInfoCreator = 
        [[[SimDateFormInfoCreator alloc] initWithVariableDateFieldInfo:self.fieldInfo 
          andDefaultValFieldInfo:self.defaultValFieldInfo 
		  andVarDateRuntimeInfo:self.varDateRuntimeInfo
		  andDoShowEndDates:showEndDates andDefaultRelEndDateFieldInfo:self.defaultRelEndDateFieldInfo] autorelease];
    
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
	[defaultRelEndDateFieldInfo release];
	[subtitleFormatter release];
}


@end
