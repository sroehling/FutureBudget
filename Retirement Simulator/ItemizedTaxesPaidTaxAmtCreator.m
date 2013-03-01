//
//  ItemizedTaxesPaidTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxesPaidTaxAmtCreator.h"
#import "TaxInput.h"
#import "StringValidation.h"
#import "FormContext.h"
#import "InputCreationHelper.h"
#import "TaxesPaidItemizedTaxAmt.h"
#import "SharedAppValues.h"
#import "DataModelController.h"

@implementation ItemizedTaxesPaidTaxAmtCreator

@synthesize tax;
@synthesize formContext;
@synthesize label;

-(id)initWithFormContext:(FormContext*)theFormContext
	andTax:(TaxInput*)theTax andLabel:(NSString*)theLabel
{
	self = [super init];
	if(self)
	{
		assert(theTax != nil);
		self.tax = theTax;
		
		assert([StringValidation nonEmptyString:theLabel]);
		self.label = theLabel;
		
		assert(theFormContext != nil);
		self.formContext = theFormContext;
	}
	return self;
}

-(id)init
{
	assert(0); // must init with asset
	return nil;
}

- (ItemizedTaxAmt*)createItemizedTaxAmt
{
	TaxesPaidItemizedTaxAmt *itemizedTaxAmt = [self.formContext.dataModelController insertObject:TAXES_PAID_ITEMIZED_TAX_AMT_ENTITY_NAME];
	SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:self.formContext.dataModelController];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initWithDataModelController:self.formContext.dataModelController
		andSharedAppVals:sharedAppVals] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.tax  = self.tax;
	return itemizedTaxAmt;
}


-(NSString*)itemLabel
{
	return self.label;
}

-(void)dealloc
{
	[tax release];
	[label release];
	[formContext release];
	[super dealloc];
}

@end
