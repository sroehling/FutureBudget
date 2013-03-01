//
//  ItemizedIncomeTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedIncomeTaxAmtCreator.h"
#import "DataModelController.h"
#import "InputCreationHelper.h"
#import "IncomeItemizedTaxAmt.h"
#import "StringValidation.h"
#import "FormContext.h"
#import "SharedAppValues.h"

@implementation ItemizedIncomeTaxAmtCreator

@synthesize income;
@synthesize label;
@synthesize formContext;

- (id)initWithFormContext:(FormContext*)theFormContext andIncome:(IncomeInput*)theIncome
	andItemLabel:(NSString*)theItemLabel
{
	self = [super init];
	if(self)
	{
		assert(theFormContext != nil);
		self.formContext = theFormContext;
		
		assert(theIncome != nil);
		self.income = theIncome;
		
		assert([StringValidation nonEmptyString:theItemLabel]);
		self.label = theItemLabel;
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
	assert(income != nil);
	IncomeItemizedTaxAmt *itemizedTaxAmt = [self.formContext.dataModelController insertObject:INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME];
	SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:self.formContext.dataModelController];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initWithDataModelController:self.formContext.dataModelController
		andSharedAppVals:sharedAppVals] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.income  = self.income;
	return itemizedTaxAmt;

}

-(NSString*)itemLabel
{
	return self.label;
}


-(void)dealloc
{
	[income release];
	[label release];
	[formContext release];
	[super dealloc];
}


@end
