//
//  DateSensitiveValueChangeFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueChangeFieldEditInfo.h"
#import "DateSensitiveValueChangeFormInfoCreator.h"
#import "DateSensitiveValueChange.h"
#import "VariableValueRuntimeInfo.h"
#import "DateHelper.h"
#import "NumberHelper.h"
#import "ValueSubtitleTableCell.h"
#import "SimDate.h"
#import "LocalizationHelper.h"
#import "DataModelController.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "FormContext.h"

@implementation DateSensitiveValueChangeFieldEditInfo

@synthesize varValInfo;
@synthesize valChange;
@synthesize valChangeCell;
@synthesize variableVal;
@synthesize parentController;
@synthesize dateHelper;


- (void) dealloc
{
	[varValInfo release];
	[valChange release];
	[valChangeCell release];
	[variableVal release];
    [dateHelper release];
    
	[super dealloc];
}

- (void) configureCell
{
	self.valChangeCell.caption.text = 
		[self.dateHelper.mediumDateFormatter stringFromDate:self.valChange.startDate.date];
	self.valChangeCell.valueDescription.text = [[NumberHelper theHelper] displayStrFromStoredVal:self.valChange.valueAfterChange andFormatter:self.varValInfo.valueFormatter];;

}

- (id) initWithValueChange:(DateSensitiveValueChange*)valueChange 
andVariableValueRuntimeInfo:(VariableValueRuntimeInfo*)varValueInfo
andVariableValue:(VariableValue*)theVariableVal andParentController:(UIViewController*)theController
{
		self = [super init];
		if(self)
		{
			assert(varValueInfo!=nil);
			self.varValInfo = varValueInfo;
			
			assert(valueChange!=nil);
			self.valChange = valueChange;
			
			self.variableVal = theVariableVal;
			
			assert(theController != nil);
			self.parentController = theController;
			
			self.valChangeCell = [[[ValueSubtitleTableCell alloc] init] autorelease];
			self.valChangeCell.supportsDelete = TRUE;
            
            self.dateHelper = [[[DateHelper alloc] init] autorelease];
            
			[self configureCell];
			

		}
		return self;
}

- (id) init
{
	assert(0); // must not call this init
	return nil;
}


- (NSString*)detailTextLabel
{
	NSNumber *displayVal = [[NumberHelper theHelper] displayValFromStoredVal:self.valChange.valueAfterChange andFormatter:self.varValInfo.valueFormatter];
	return [NSString stringWithFormat:@"%@ - %@",
			[self.varValInfo.valueFormatter stringFromNumber:displayVal],
			[self.dateHelper.mediumDateFormatter stringFromDate:self.valChange.startDate.date] ];
}

- (NSString*)textLabel
{
    return [NSString stringWithFormat:LOCALIZED_STR(@"VALUE_CHANGE_NEW_VALUE_FORMAT"),
	 LOCALIZED_STR(self.varValInfo.valueTitleKey)];
}

- (UIViewController*)fieldEditController:(FormContext*)parentContext
{
	DateSensitiveValueChangeFormInfoCreator *formInfoCreator = [[[DateSensitiveValueChangeFormInfoCreator alloc]
		initForValueChange:self.valChange andVariableValRuntimeInfo:self.varValInfo
		 andParentVariableValue:self.variableVal] autorelease];

    UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc]
			initWithFormInfoCreator:formInfoCreator
			andDataModelController:parentContext.dataModelController] autorelease];

	return controller;
 }

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return [self.valChangeCell cellHeight];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    assert(tableView!=nil);
	[self configureCell];
    return self.valChangeCell;
}


- (BOOL)fieldIsInitializedInParentObject
{
    return TRUE;
}


- (NSManagedObject*) managedObject
{
    return self.valChange;
}

-(BOOL)supportsDelete
{
	return TRUE;
}


-(void)deleteObject:(DataModelController*)dataModelController
{
	assert(self.valChange != nil);
	[dataModelController deleteObject:self.valChange];
	self.valChange = nil;
}



@end
