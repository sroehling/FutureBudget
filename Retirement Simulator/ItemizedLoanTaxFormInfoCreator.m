//
//  ItemizedLoanTaxFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemizedLoanTaxFormInfoCreator.h"

#import "FormInfo.h"
#import "LoanInput.h"
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
#import "FormContext.h"
#import "LoanInterestItemizedTaxAmt.h"
#import "StringValidation.h"

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

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject
			andFormContext:parentContext] autorelease];
			
	formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_LOAN_TAXES_TITLE");
	
	NSString *formHeader = [StringValidation nonEmptyString:self.loan.name]?
		[NSString
		stringWithFormat:LOCALIZED_STR(@"INPUT_LOAN_TAX_DETAIL_HEADER_FORMAT"),
		self.loan.name]:LOCALIZED_STR(@"INPUT_LOAN_TAX_DETAIL_HEADER_NAME_UNDEFINED");

	[formPopulator populateWithHeader:formHeader
	andSubHeader:LOCALIZED_STR(@"INPUT_LOAN_TAX_DETAIL_SUBHEADER")];

	
	NSSet *inputs = [parentContext.dataModelController 
			fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME];
	if([inputs count] > 0)
	{
		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_TAX_ITEMIZED_ADJUSTMENT_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxAdjustInfo = [ItemizedTaxAmtsInfo taxAdjustmentInfo:tax
				usingDataModelController:parentContext.dataModelController];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxAdjustInfo 
				andTaxAmt:[taxAdjustInfo.fieldPopulator findItemizedLoanInterest:self.loan] 
				andTaxAmtCreator:[[[ItemizedLoanInterestTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andLoan:self.loan andLabel:tax.name] autorelease]];
		}

		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_TAX_ITEMIZED_DEDUCTABLE_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxDeductionInfo = [ItemizedTaxAmtsInfo taxDeductionInfo:tax
				usingDataModelController:parentContext.dataModelController];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxDeductionInfo 
				andTaxAmt:[taxDeductionInfo.fieldPopulator findItemizedLoanInterest:self.loan] 
				andTaxAmtCreator:[[[ItemizedLoanInterestTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andLoan:self.loan andLabel:tax.name] autorelease]];
		}


		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_LOAN_TAX_ITEMIZED_CREDIT_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxCreditInfo = [ItemizedTaxAmtsInfo taxCreditInfo:tax
				usingDataModelController:parentContext.dataModelController];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxCreditInfo 
				andTaxAmt:[taxCreditInfo.fieldPopulator findItemizedLoanInterest:self.loan] 
				andTaxAmtCreator:[[[ItemizedLoanInterestTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andLoan:self.loan andLabel:tax.name] autorelease]];
		}

	}

	return formPopulator.formInfo;
	
}


-(void)dealloc
{
	[loan release];
	[super dealloc];
}


@end
