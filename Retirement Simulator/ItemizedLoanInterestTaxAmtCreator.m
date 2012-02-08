//
//  ItemizedLoanInterestTaxAmtCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedLoanInterestTaxAmtCreator.h"
#import "InputCreationHelper.h"
#import "DataModelController.h"
#import "LoanInput.h"
#import "LoanInterestItemizedTaxAmt.h"
#import "StringValidation.h"


@implementation ItemizedLoanInterestTaxAmtCreator

@synthesize loan;
@synthesize label;

-(id)initWithLoan:(LoanInput*)theLoan andLabel:(NSString*)theLabel
{
	self = [super init];
	if(self)
	{
		assert(theLoan != nil);
		self.loan = theLoan;
		
		assert([StringValidation nonEmptyString:theLabel]);
		self.label = theLabel;
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
	assert(loan != nil);
	LoanInterestItemizedTaxAmt *itemizedTaxAmt = [[DataModelController theDataModelController] insertObject:LOAN_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME];
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc] 
		initForDatabaseInputs] autorelease];
	itemizedTaxAmt.multiScenarioApplicablePercent = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.loan  = self.loan;
	return itemizedTaxAmt;
}


-(NSString*)itemLabel
{
	return self.label;
}

-(void)dealloc
{
	[super dealloc];
	[loan release];
	[label release];
}



@end
