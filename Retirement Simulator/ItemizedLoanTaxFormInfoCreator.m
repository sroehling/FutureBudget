//
//  ItemizedLoanTaxFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemizedLoanTaxFormInfoCreator.h"

#import "FormInfo.h"
#import "InputFormPopulator.h"
#import "AssetInput.h"
#import "DataModelController.h"
#import "TaxInput.h"
#import "LocalizationHelper.h"
#import "ItemizedTaxAmtsInfo.h"
#import "SectionInfo.h"
#import "ItemizedTaxAmtsInfo.h"
#import "ItemizedTaxAmtFieldPopulator.h"
#import "ItemizedLoanInterestTaxAmtCreator.h"
#import "ItemizedTaxAmtFieldEditInfo.h"
#import "LoanInterestItemizedTaxAmt.h"

@implementation ItemizedLoanTaxFormInfoCreator

@synthesize loan;
@synthesize isForNewObject;

-(id)initWithLoan:(LoanInput*)theLoan andIsForNewObject:(BOOL)forNewObject
{
	self = [super init];
	if(self)
	{
		assert(theLoan != nil);
		self.loan = theLoan;
		
		self.isForNewObject = forNewObject;
	}
	return self;
}

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject
			andParentController:parentController] autorelease];
			
	formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_LOAN_TAXES_TITLE");
	
	NSSet *inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME];
	if([inputs count] > 0)
	{
		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_TAX_ITEMIZED_ADJUSTMENT_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxAdjustInfo = [ItemizedTaxAmtsInfo taxAdjustmentInfo:tax];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxAdjustInfo 
				andTaxAmt:[taxAdjustInfo.fieldPopulator findItemizedLoanInterest:self.loan] 
				andTaxAmtCreator:[[[ItemizedLoanInterestTaxAmtCreator alloc] 
					initWithLoan:self.loan andLabel:tax.name] autorelease]];
		}

		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_TAX_ITEMIZED_DEDUCTABLE_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxDeductionInfo = [ItemizedTaxAmtsInfo taxDeductionInfo:tax];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxDeductionInfo 
				andTaxAmt:[taxDeductionInfo.fieldPopulator findItemizedLoanInterest:self.loan] 
				andTaxAmtCreator:[[[ItemizedLoanInterestTaxAmtCreator alloc] 
					initWithLoan:self.loan andLabel:tax.name] autorelease]];
		}


		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_TAX_ITEMIZED_CREDIT_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxCreditInfo = [ItemizedTaxAmtsInfo taxCreditInfo:tax];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxCreditInfo 
				andTaxAmt:[taxCreditInfo.fieldPopulator findItemizedLoanInterest:self.loan] 
				andTaxAmtCreator:[[[ItemizedLoanInterestTaxAmtCreator alloc] 
					initWithLoan:self.loan andLabel:tax.name] autorelease]];
		}

	}

	return formPopulator.formInfo;
	
}


-(void)dealloc
{
	[super dealloc];
	[loan release];
}


@end
