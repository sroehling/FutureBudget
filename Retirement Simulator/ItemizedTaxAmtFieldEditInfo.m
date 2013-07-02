//
//  ItemizedTaxAmtFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtFieldEditInfo.h"

#import "ItemizedTaxAmt.h"
#import "ExpenseInput.h"
#import "Account.h"
#import "StaticNameFieldCell.h"
#import "DataModelController.h"
#import "ItemizedTaxAmts.h"
#import "InputFormPopulator.h"
#import "GenericFieldBasedTableEditViewController.h"
#import "StaticFormInfoCreator.h"
#import "ItemizedTaxAmtsInfo.h"
#import "ItemizedTaxAmt.h"
#import "PercentFieldValidator.h"
#import "FormContext.h"

@implementation ItemizedTaxAmtFieldEditInfo

@synthesize itemizedTaxAmts;
@synthesize itemizedTaxAmtCreator;
@synthesize itemizedTaxAmt;
@synthesize itemizedTaxAmtsInfo;
@synthesize dataModelController;

-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts 
	andItemizedTaxAmtCreator:(id<ItemizedTaxAmtCreator>)theItemizedTaxAmtCreator
	andItemizedTaxAmt:(ItemizedTaxAmt*)theItemizedTaxAmt
	andItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo
	andIsForNewObject:(BOOL)forNewObject
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmts != nil);
		self.itemizedTaxAmts = theItemizedTaxAmts;
		
		assert(theItemizedTaxAmtCreator != nil);
		self.itemizedTaxAmtCreator = theItemizedTaxAmtCreator;
		
		self.itemizedTaxAmt = theItemizedTaxAmt;
		assert((self.itemizedTaxAmt == nil) || 
			[self.itemizedTaxAmts.itemizedAmts containsObject:self.itemizedTaxAmt]);
		
		self.itemizedTaxAmtsInfo = theItemizedTaxAmtsInfo;
		
		assert(theDataModelController != nil);
		self.dataModelController = theDataModelController;
		
		isForNewObject = forNewObject;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)dealloc
{
	[itemizedTaxAmts release];
	[itemizedTaxAmtCreator release];
	[itemizedTaxAmt release];
	[itemizedTaxAmtsInfo release];
	[super dealloc];
}



- (NSString*)detailTextLabel
{
    return @"";
}

- (NSString*)textLabel
{
	return @"";
}

- (UIViewController*)fieldEditController:(FormContext*)parentContext
{
	if(self.itemizedTaxAmt == nil)
	{
		// If self.itemizedTaxAmt is already initialized, then we create it, but
		// keep it initially disabled.
		self.itemizedTaxAmt = [self.itemizedTaxAmtCreator createItemizedTaxAmt];
		self.itemizedTaxAmt.isEnabled = [NSNumber numberWithBool:FALSE];
		[self.itemizedTaxAmts addItemizedAmtsObject:self.itemizedTaxAmt];
	}
	
	InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:isForNewObject
		andFormContext:parentContext] autorelease];
	formPopulator.formInfo.title = self.itemizedTaxAmtsInfo.itemTitle;
	
	[formPopulator nextSection];
	
	[formPopulator populateMultiScenPercentField:self.itemizedTaxAmt.multiScenarioApplicablePercent 
	     andValLabel:self.itemizedTaxAmtsInfo.amtPrompt andPrompt:self.itemizedTaxAmtsInfo.amtPrompt
		 andAllowGreaterThan100Percent:FALSE];
		
	StaticFormInfoCreator *formInfoCreator = 
		[[[StaticFormInfoCreator alloc] initWithFormInfo:formPopulator.formInfo] autorelease];
	GenericFieldBasedTableEditViewController *controller = 
		[[[GenericFieldBasedTableEditViewController alloc] 
			initWithFormInfoCreator:formInfoCreator
			andDataModelController:parentContext.dataModelController] autorelease];
	return controller;
}

- (CGFloat)cellHeightForWidth:(CGFloat)width
{
	return 30.0;
}

- (BOOL)fieldIsInitializedInParentObject
{
    return TRUE;
}

- (void)disableFieldAccess
{
    // no-op
}

- (NSManagedObject*) managedObject
{
    return nil;
}


- (UITableViewCell*)cellForFieldEdit:(UITableView *)tableView
{
    
    assert(tableView!=nil);
    
    StaticNameFieldCell *cell = (StaticNameFieldCell *)[tableView 
		dequeueReusableCellWithIdentifier:STATIC_NAME_FIELD_CELL_IDENTIFIER];
    if (cell == nil) {
		cell = [[[StaticNameFieldCell alloc] init] autorelease];
    }    
    cell.staticName.text = [self.itemizedTaxAmtCreator itemLabel];
	cell.staticName.textAlignment = NSTextAlignmentLeft;
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
    
}

- (BOOL)isSelected
{
	if(self.itemizedTaxAmt != nil)
	{
		return [self.itemizedTaxAmt.isEnabled boolValue];
	}
	else
	{
		return FALSE;
	}
}

- (void)updateSelection:(BOOL)isSelected
{

	if(isSelected)
	{
		if(self.itemizedTaxAmt != nil)
		{
			self.itemizedTaxAmt.isEnabled = [NSNumber numberWithBool:TRUE];
			[self.itemizedTaxAmts addItemizedAmtsObject:self.itemizedTaxAmt];
		}
		else
		{
			self.itemizedTaxAmt = [self.itemizedTaxAmtCreator createItemizedTaxAmt];
			self.itemizedTaxAmt.isEnabled = [NSNumber numberWithBool:TRUE];
			[self.itemizedTaxAmts addItemizedAmtsObject:self.itemizedTaxAmt];
		}
	}
	else
	{
		assert(self.itemizedTaxAmt != nil);
		assert([self.itemizedTaxAmts.itemizedAmts containsObject:self.itemizedTaxAmt]);
		self.itemizedTaxAmt.isEnabled = [NSNumber numberWithBool:FALSE];
	}
	[self.dataModelController saveContextAndIgnoreErrors];

}



@end
