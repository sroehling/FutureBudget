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
#import "FormContext.h"
#import "NumberFieldEditInfo.h"
#import "FormPopulator.h"
#import "NumberFieldCell.h"
#import "SectionInfo.h"
#import "StaticFormInfoCreator.h"
#import "GenericFieldBasedValuePromptTableViewController.h"


@implementation DateSensitiveValueFieldEditInfo

@synthesize varValRuntimeInfo;
@synthesize defaultFixedValFieldInfo;
@synthesize valueCell;
@synthesize isForNewValue;
@synthesize parentContextForFirstValueEdit;


- (void) dealloc
{
    [varValRuntimeInfo release];
    [defaultFixedValFieldInfo release];
	[valueCell release];
	[parentContextForFirstValueEdit release];
    [super dealloc];
}


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

- (id)initWithFieldInfo:(FieldInfo *)theFieldInfo 
	andDefaultFixedValFieldInfo:(FieldInfo*)theDefaultFieldInfo
      andValRuntimeInfo:(VariableValueRuntimeInfo *)theVarValRuntimeInfo
	  andForNewVal:(BOOL)forNewVal
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
		
		self.isForNewValue = forNewVal;
		
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

+ (DateSensitiveValueFieldEditInfo*)
	createForDataModelController:(DataModelController*)theDataModelController
	andScenario:(Scenario*)theScenario 
	andMultiScenFixedVal:(MultiScenarioInputValue*)multiScenFixedVal
	andLabel:(NSString*)label 
	andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo
	andDefaultFixedVal:(MultiScenarioInputValue*)defaultFixedVal
	andForNewVal:(BOOL)forNewVal;
{
    assert([StringValidation nonEmptyString:label]);
	assert(multiScenFixedVal != nil);
    assert(varValRuntimeInfo != nil);
    
	NSString *dsvValuePlaceholder = 
	[NSString stringWithFormat:LOCALIZED_STR(@"DATE_SENSITIVE_VALUE_VALUE_PLACEHOLDER"),
	 LOCALIZED_STR(varValRuntimeInfo.valueTitleKey)];	   

	
	MultiScenarioInputValueFieldInfo *fieldInfo = [[[MultiScenarioInputValueFieldInfo alloc]
			initWithScenario:theScenario andMultiScenarioInputVal:multiScenFixedVal 
			andFieldLabel:label andFieldPlaceholder:dsvValuePlaceholder] autorelease];
			
	   
    MultiScenarioFixedValueFieldInfo *defaultFixedValFieldInfo =
		[[[MultiScenarioFixedValueFieldInfo alloc] 
			initWithDataModelController:theDataModelController andFieldLabel:label 
			andFieldPlaceholder:dsvValuePlaceholder 
			andScenario:theScenario andInputVal:defaultFixedVal] autorelease];

    DateSensitiveValueFieldEditInfo *fieldEditInfo = [[[DateSensitiveValueFieldEditInfo alloc]
         initWithFieldInfo:fieldInfo andDefaultFixedValFieldInfo:defaultFixedValFieldInfo
          andValRuntimeInfo:varValRuntimeInfo
		  andForNewVal:forNewVal] autorelease];
     
    return fieldEditInfo;
}

+ (DateSensitiveValueFieldEditInfo*)createForObject:
			(NSManagedObject*)obj andKey:(NSString*)key andLabel:(NSString*)label 
			andValRuntimeInfo:(VariableValueRuntimeInfo *)varValRuntimeInfo
				andDefaultFixedValKey:(NSString*)defaultFixedValKey
				andForNewVal:(BOOL)forNewVal;
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
	
    ManagedObjectFieldInfo *defaultFixedValFieldInfo = [[[ManagedObjectFieldInfo alloc] initWithManagedObject:obj 
				andFieldKey:defaultFixedValKey andFieldLabel:label
				andFieldPlaceholder:dsvValuePlaceholder] autorelease];
    assert([defaultFixedValFieldInfo fieldIsInitializedInParentObject]);

    DateSensitiveValueFieldEditInfo *fieldEditInfo = [[[DateSensitiveValueFieldEditInfo alloc]                                                       
         initWithFieldInfo:fieldInfo andDefaultFixedValFieldInfo:defaultFixedValFieldInfo
          andValRuntimeInfo:varValRuntimeInfo
		  andForNewVal:forNewVal] autorelease];
     
    return fieldEditInfo;
}


- (NSString*)detailTextLabel
{
    DateSensitiveValue *dsValue = [self.fieldInfo getFieldValue];
    return [dsValue valueDescription:self.varValRuntimeInfo];
}


-(SelectableObjectTableEditViewController*)viewControllerForDateSensitiveVal:(FormContext*)parentContext
{
	DateSensitiveValueFormInfoCreator *dsvFormInfoCreator = 
	[[[DateSensitiveValueFormInfoCreator alloc] initWithVariableValueFieldInfo:self.fieldInfo 
		andDefaultValFieldInfo:self.defaultFixedValFieldInfo 
		andVarValRuntimeInfo:self.varValRuntimeInfo
		andIsForNewValue:self.isForNewValue] autorelease];
		
	SelectableObjectTableEditViewController *dsValueController = 
			[[[SelectableObjectTableEditViewController alloc] initWithFormInfoCreator:dsvFormInfoCreator 
				  andAssignedField:self.fieldInfo
				  andDataModelController:parentContext.dataModelController] autorelease];
	dsValueController.loadInEditModeIfAssignedFieldNotSet = self.isForNewValue?TRUE:FALSE;

	return dsValueController;
}


- (UIViewController*)fieldEditController:(FormContext*)parentContext
{

	if([self.defaultFixedValFieldInfo fieldIsInitializedInParentObject])
	{			  
		return [self viewControllerForDateSensitiveVal:parentContext];
	}
	else
	{
		// If the amount field is uninitialized, show a dedicated popup to
		// get the initial fixed amount value.
		FormPopulator *formPopulator = [[[FormPopulator alloc]
			initWithFormContext:parentContext] autorelease];
		self.parentContextForFirstValueEdit = parentContext;
			
		formPopulator.formInfo.title = LOCALIZED_STR(self.varValRuntimeInfo.valueTitleKey);

		[formPopulator nextSection];
		NumberFieldEditInfo *valueFieldEditInfo =
			[[[NumberFieldEditInfo alloc]initWithFieldInfo:self.defaultFixedValFieldInfo
			 andNumberFormatter:self.varValRuntimeInfo.valueFormatter
			 andValidator:self.varValRuntimeInfo.valueValidator] autorelease];
		valueFieldEditInfo.isDefaultSelection = TRUE;
		[formPopulator.currentSection addFieldEditInfo:valueFieldEditInfo];
	 
		formPopulator.formInfo.firstResponder = valueFieldEditInfo.numberCell.textField;
		
		StaticFormInfoCreator *fieldValFormInfoCreator = [[[StaticFormInfoCreator alloc]
		initWithFormInfo:formPopulator.formInfo] autorelease];
		
		GenericFieldBasedValuePromptTableViewController *firstValueEditViewController =
			[[[GenericFieldBasedValuePromptTableViewController alloc]
			initWithFormInfoCreator:fieldValFormInfoCreator
			andDataModelController:parentContext.dataModelController] autorelease];
		firstValueEditViewController.delegate = self;
		
		
		return firstValueEditViewController;

	}

}


-(void)genericFieldBasedValuePromptTableViewDonePromptingForValues
{
	NSLog(@"Save complete for new value");
	
	assert([self.defaultFixedValFieldInfo fieldIsInitializedInParentObject]);
	[self.fieldInfo setFieldValue:[self.defaultFixedValFieldInfo managedObject]];
 
	assert(self.parentContextForFirstValueEdit != nil);
	
	SelectableObjectTableEditViewController *dsValueController =
		[self viewControllerForDateSensitiveVal:self.parentContextForFirstValueEdit];

	[self.parentContextForFirstValueEdit.parentController.navigationController
		popViewControllerAnimated:FALSE];
		 
	[self.parentContextForFirstValueEdit.parentController.navigationController
		pushViewController:dsValueController animated:FALSE];

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



@end
