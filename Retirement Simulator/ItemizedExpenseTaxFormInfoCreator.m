//
//  ItemizedExpenseTaxFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemizedExpenseTaxFormInfoCreator.h"

#import "ExpenseInput.h"
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
#import "ItemizedAssetGainTaxAmtCreator.h"
#import "ItemizedTaxAmtFieldEditInfo.h"
#import "ItemizedExpenseTaxAmtCreator.h"
#import "FormContext.h"
#import "ExpenseItemizedTaxAmt.h"

@implementation ItemizedExpenseTaxFormInfoCreator

@synthesize expense;
@synthesize isForNewObject;

-(id)initWithExpense:(ExpenseInput*)theExpense andIsForNewObject:(BOOL)forNewObject
{
	self = [super init];
	if(self)
	{
		assert(theExpense != nil);
		self.expense = theExpense;
		
		self.isForNewObject = forNewObject;
	}
	return self;
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject
			andFormContext:parentContext] autorelease];
			
	formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_EXPENSE_TAXES_TITLE");

	[formPopulator populateWithHeader:[NSString stringWithFormat:LOCALIZED_STR(@"INPUT_EXPENSE_TAX_DETAIL_HEADER_FORMAT"),
			self.expense.name]
		andSubHeader:LOCALIZED_STR(@"INPUT_EXPENSE_TAX_DETAIL_SUBHEADER")];

	
	NSSet *inputs = [parentContext.dataModelController 
			fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME];
	if([inputs count] > 0)
	{
		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_EXPENSE_ITEMIZED_DEDUCTION_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxDeductionInfo = [ItemizedTaxAmtsInfo taxDeductionInfo:tax
				usingDataModelController:parentContext.dataModelController];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxDeductionInfo 
				andTaxAmt:[taxDeductionInfo.fieldPopulator findItemizedExpense:self.expense] 
				andTaxAmtCreator:[[[ItemizedExpenseTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andExpense:self.expense andLabel:tax.name] autorelease]];
		}


		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_EXPENSE_ITEMIZED_ADJUSTMENT_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxAdjustInfo = [ItemizedTaxAmtsInfo taxAdjustmentInfo:tax
				usingDataModelController:parentContext.dataModelController];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxAdjustInfo 
				andTaxAmt:[taxAdjustInfo.fieldPopulator findItemizedExpense:self.expense] 
				andTaxAmtCreator:[[[ItemizedExpenseTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andExpense:self.expense andLabel:tax.name] autorelease]];
		}

		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_EXPENSE_ITEMIZED_CREDIT_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxCreditInfo = [ItemizedTaxAmtsInfo taxCreditInfo:tax
				usingDataModelController:parentContext.dataModelController];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxCreditInfo 
				andTaxAmt:[taxCreditInfo.fieldPopulator findItemizedExpense:self.expense] 
				andTaxAmtCreator:[[[ItemizedExpenseTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andExpense:self.expense andLabel:tax.name] autorelease]];
				
		}


	}

	return formPopulator.formInfo;
	
}


-(void)dealloc
{
	[expense release];
	[super dealloc];
}




@end
