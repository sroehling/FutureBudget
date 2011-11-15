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

    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
    [variableVal release];
	[varValRuntimeInfo release];
	[varValueCell release];
}

- (NSString*)detailTextLabel
{
	return [self.variableVal standaloneDescription:self.varValRuntimeInfo];
}

- (NSString*)textLabel
{
    return self.variableVal.name;
}

- (UIViewController*)fieldEditController
{

	VariableValueFormInfoCreator *vvFormInfoCreator = 
		[[[VariableValueFormInfoCreator alloc] initWithVariableValue:self.variableVal
		andVarValueRuntimeInfo:self.varValRuntimeInfo] autorelease];
		
	UIViewController *controller = [[[GenericFieldBasedTableEditViewController alloc]
	    initWithFormInfoCreator:vvFormInfoCreator] autorelease];
		
	return controller;
}

- (BOOL)hasFieldEditController
{
    return TRUE;
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
	return TRUE;
}

-(void)deleteObject
{
	assert(self.variableVal != nil);
	[[DataModelController theDataModelController] deleteObject:self.variableVal];
	self.variableVal = nil;
}

@end
