//
//  VariableValueFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VariableValueFieldEditInfo.h"
#import "TableViewHelper.h"
#import "StringValidation.h"
#import "FormPopulator.h"
#import "NumberHelper.h"
#import "MilestoneDate.h"
#import "FormInfo.h"
#import "VariableValue.h"
#import "SectionInfo.h"
#import "DateHelper.h"
#import "VariableValueRuntimeInfo.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "VariableValueFormInfoCreator.h"
#import "ValueSubtitleTableCell.h"
#import "DataModelController.h"
#import "FormContext.h"

@implementation VariableValueFieldEditInfo


@synthesize variableVal;
@synthesize varValRuntimeInfo;
@synthesize varValueCell;


- (void) configureCell
{
	self.varValueCell.caption.text = [self textLabel];
	self.varValueCell.valueDescription.text = [self.variableVal valueDescription:self.varValRuntimeInfo];
    self.varValueCell.valueSubtitle.text = [self.variableVal standaloneDescription:self.varValRuntimeInfo];

}

- (id)initWithVariableValue:(VariableValue*)varValue
	   andVarValRuntimeInfo:(VariableValueRuntimeInfo*)theVarValRuntimeInfo
{

    self = [super init];
    if(self)
    {
		assert(varValue != nil);
		self.variableVal = varValue;
		assert(theVarValRuntimeInfo != nil);
		self.varValRuntimeInfo = theVarValRuntimeInfo;
		
		self.varValueCell = [[[ValueSubtitleTableCell alloc] init] autorelease];
		[self configureCell];
		
		self.variableVal.isSelectedInTableView = FALSE;

    }
    return self;
}

- (void) dealloc
{
    [variableVal release];
	[varValRuntimeInfo release];
	[varValueCell release];
    [super dealloc];
}

- (NSString*)detailTextLabel
{
	return [self.variableVal standaloneDescription:self.varValRuntimeInfo];
}

- (NSString*)textLabel
{
    return self.variableVal.label;
}

- (UIViewController*)fieldEditController:(FormContext*)parentContext
{

	VariableValueFormInfoCreator *vvFormInfoCreator = 
		[[[VariableValueFormInfoCreator alloc] initWithVariableValue:self.variableVal
		andVarValueRuntimeInfo:self.varValRuntimeInfo] autorelease];
		
	UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc]
	    initWithFormInfoCreator:vvFormInfoCreator andDataModelController:parentContext.dataModelController] autorelease];
		
	return controller;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return [self.varValueCell cellHeight];
}

- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{;
	[self configureCell];
	return [self varValueCell];

}


- (BOOL)fieldIsInitializedInParentObject
{
    return TRUE;
}

- (void)disableFieldAccess
{
    // no-op
    // TBD - should this be a no-op
}

- (NSManagedObject*) managedObject
{
    return self.variableVal;
}

-(BOOL)supportsDelete
{
	return [self.variableVal supportsDeletion];
}

- (void)deleteObject:(DataModelController*)dataModelController
{
	assert(self.variableVal != nil);
	[dataModelController deleteObject:self.variableVal];
	self.variableVal = nil;
}

- (BOOL)isSelected
{
	return self.variableVal.isSelectedInTableView;
}

- (void)updateSelection:(BOOL)isSelected
{
	self.variableVal.isSelectedInTableView = isSelected;
}

@end
