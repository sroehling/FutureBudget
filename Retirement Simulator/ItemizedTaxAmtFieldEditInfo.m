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

@implementation ItemizedTaxAmtFieldEditInfo

@synthesize itemizedTaxAmts;
@synthesize itemizedTaxAmtCreator;
@synthesize itemizedTaxAmt;
@synthesize itemizedTaxAmtsInfo;

-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts 
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
		
		self.itemizedTaxAmtsInfo = theItemizedTaxAmtsInfo;
		
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
	[super dealloc];
	[itemizedTaxAmts release];
	[itemizedTaxAmtCreator release];
	[itemizedTaxAmt release];
	[itemizedTaxAmtsInfo release];
}



- (NSString*)detailTextLabel
{
    return @"";
}

- (NSString*)textLabel
{
	return @"";
}

- (UIViewController*)fieldEditController
{
	assert(self.itemizedTaxAmt != nil);
	
	InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initForNewObject:isForNewObject] autorelease];
	formPopulator.formInfo.title = self.itemizedTaxAmtsInfo.itemTitle;
	
	[formPopulator nextSection];
	[formPopulator populateMultiScenFixedValField:self.itemizedTaxAmt.multiScenarioApplicablePercent 
		andValLabel:self.itemizedTaxAmtsInfo.amtPrompt 
		andPrompt:self.itemizedTaxAmtsInfo.amtPrompt
		andValidator:[[[PercentFieldValidator alloc] init] autorelease]];
	
	StaticFormInfoCreator *formInfoCreator = 
		[[[StaticFormInfoCreator alloc] initWithFormInfo:formPopulator.formInfo] autorelease];
	GenericFieldBasedTableEditViewController *controller = 
		[[[GenericFieldBasedTableEditViewController alloc] 
			initWithFormInfoCreator:formInfoCreator] autorelease];
	return controller;
}

- (BOOL)hasFieldEditController
{
	if(self.itemizedTaxAmt != nil)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
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
	cell.staticName.textAlignment = UITextAlignmentLeft;
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	if([self hasFieldEditController])
	{
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	else
	{
		cell.editingAccessoryType = UITableViewCellAccessoryNone;
	}
    
	return cell;
    
}

- (BOOL)isSelected
{
	if(self.itemizedTaxAmt != nil)
	{
		if([self.itemizedTaxAmts.itemizedAmts containsObject:self.itemizedTaxAmt])
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	return FALSE;
}

- (void)updateSelection:(BOOL)isSelected
{

	if(isSelected)
	{
		if(self.itemizedTaxAmt != nil)
		{
			[self.itemizedTaxAmts addItemizedAmtsObject:self.itemizedTaxAmt];
		}
		else
		{
			self.itemizedTaxAmt = [self.itemizedTaxAmtCreator createItemizedTaxAmt];
			[self.itemizedTaxAmts addItemizedAmtsObject:self.itemizedTaxAmt];
		}
	}
	else
	{
		assert(self.itemizedTaxAmt != nil);
		assert([self.itemizedTaxAmts.itemizedAmts containsObject:self.itemizedTaxAmt]);
		[self.itemizedTaxAmts removeItemizedAmtsObject:self.itemizedTaxAmt];
		[[DataModelController theDataModelController] deleteObject:self.itemizedTaxAmt];
		self.itemizedTaxAmt = nil;
		
		// TODO - Need to preserve the ItemizedTaxAmt, since it may have a percentage
		// that has been set, and we don't want to delete this each and every time an
		// itemized tax amount is selected or deselected.
	}
	[[DataModelController theDataModelController] saveContext];

}



@end
