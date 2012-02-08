//
//  ExpenseItemizedTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedExpenseTaxAmtCreator.h"
#import "ExpenseItemizedTaxAmt.h"
#import "DataModelController.h"
#import "InputCreationHelper.h"
#import "ExpenseInput.h"
#import "StringValidation.h"

@implementation ItemizedExpenseTaxAmtCreator

@synthesize expense;
@synthesize label;

- (id)initWithExpense:(ExpenseInput*)theExpense andLabel:(NSString*)theLabel
{
	self = [super init];
	if(self)
	{
		assert(theExpense != nil);
		self.expense = theExpense;
		
		assert([StringValidation nonEmptyString:theLabel]);
		self.label = theLabel;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

- (ItemizedTaxAmt*)createItemizedTaxAmt
{
	assert(expense != nil);
	ExpenseItemizedTaxAmt *itemizedTaxAmt = [[DataModelController theDataModelController] insertObject:EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initForDatabaseInputs] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.expense  = self.expense;
	return itemizedTaxAmt;

}

-(NSString*)itemLabel
{
	return self.label;
}


-(void)dealloc
{
	[super dealloc];
	[expense release];
	[label release];
}



@end
