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
#import "FormContext.h"
#import "SharedAppValues.h"

@implementation ItemizedExpenseTaxAmtCreator

@synthesize expense;
@synthesize label;
@synthesize formContext;

- (id)initWithFormContext:(FormContext*)theFormContext 
		andExpense:(ExpenseInput*)theExpense andLabel:(NSString*)theLabel
{
	self = [super init];
	if(self)
	{
	
		assert(theFormContext != nil);
		self.formContext = theFormContext;
		
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
	
	SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:self.formContext.dataModelController];
	
	ExpenseItemizedTaxAmt *itemizedTaxAmt = [self.formContext.dataModelController 
				insertObject:EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initWithDataModelInterface:self.formContext.dataModelController
		 andSharedAppVals:sharedAppVals] autorelease];
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
	[expense release];
	[label release];
	[super dealloc];
}



@end
