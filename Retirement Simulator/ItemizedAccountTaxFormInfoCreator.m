//
//  ItemizedAccountTaxFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemizedAccountTaxFormInfoCreator.h"
#import "ItemizedIncomeTaxFormInfoCreator.h"

#import "InputFormPopulator.h"
#import "SectionInfo.h"
#import "ItemizedTaxAmtsInfo.h"
#import "LocalizationHelper.h"
#import "DataModelController.h"
#import "TaxInput.h"
#import "ItemizedTaxAmtFieldPopulator.h"
#import "ItemizedTaxAmts.h"
#import "ItemizedIncomeTaxAmtCreator.h"
#import "ItemizedTaxAmtFieldEditInfo.h"
#import "IncomeItemizedTaxAmt.h"
#import "Account.h"
#import "AccountContribItemizedTaxAmt.h"
#import "AccountWithdrawalItemizedTaxAmt.h"
#import "AccountInterestItemizedTaxAmt.h"

#import "ItemizedAccountContribTaxAmtCreator.h"
#import "ItemizedAccountTaxAmtCreator.h"
#import "ItemizedAccountWithdrawalTaxAmtCreator.h"
#import "FormContext.h"
#import "StringValidation.h"

@implementation ItemizedAccountTaxFormInfoCreator

@synthesize account;
@synthesize isForNewObject;
@synthesize showContributions;
@synthesize showWithdrawal;
@synthesize showInterest;


-(id)initWithAcct:(Account*)theAccount andIsForNewObject:(BOOL)forNewObject
{
	self = [super init];
	if(self)
	{
		assert(theAccount != nil);
		self.account = theAccount;
		
		self.isForNewObject = forNewObject;
		
		self.showInterest = FALSE;
		self.showContributions = FALSE;
		self.showWithdrawal = FALSE;
	}
	return self;
}

-(void)populateItemizedTax:(InputFormPopulator*)formPopulator
	fromItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)itemizedTaxAmtsInfo
	andItemizedTaxAmt:(ItemizedTaxAmt*)itemizedTaxAmt
	andItemizedTaxAmtCreator:(id<ItemizedTaxAmtCreator>)taxAmtCreator
{
	
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject
			andFormContext:parentContext] autorelease];
			
	formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_ACCOUNT_TAXES_TITLE");
	
	NSString *formHeader = [StringValidation nonEmptyString:self.account.name]?
		[NSString
		stringWithFormat:LOCALIZED_STR(@"INPUT_ACCOUNT_TAX_DETAIL_HEADER_FORMAT"),
		self.account.name]:LOCALIZED_STR(@"INPUT_ACCOUNT_TAX_DETAIL_HEADER_NAME_UNDEFINED");
	
	[formPopulator populateWithHeader:formHeader
	andSubHeader:LOCALIZED_STR(@"INPUT_ACCOUNT_TAX_DETAIL_SUBHEADER")];

	
	NSSet *inputs = [parentContext.dataModelController 
			fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME];
	if([inputs count] > 0)
	{
		
		if(self.showContributions)
		{
			[formPopulator nextSectionWithTitle:
					LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_DEDUCTABLE_CONTRIBUTIONS_SECTION_HEADER")];
			for(TaxInput *tax in inputs)
			{
				ItemizedTaxAmtsInfo *taxDeductionInfo = [ItemizedTaxAmtsInfo taxDeductionInfo:tax
					usingDataModelController:parentContext.dataModelController];
				[formPopulator populateItemizedTaxForTaxAmtsInfo:taxDeductionInfo
						andTaxAmt:[taxDeductionInfo.fieldPopulator findItemizedAcctContrib:self.account] 
						andTaxAmtCreator:[[[ItemizedAccountContribTaxAmtCreator alloc] 
							initWithFormContext:parentContext
							andAcct:self.account andLabel:tax.name] autorelease]];
			}

			[formPopulator nextSectionWithTitle:
					LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_ADJUSTABLE_CONTRIBUTIONS_SECTION_HEADER")];
			for(TaxInput *tax in inputs)
			{
				ItemizedTaxAmtsInfo *taxAdjustmentInfo = [ItemizedTaxAmtsInfo taxAdjustmentInfo:tax
					usingDataModelController:parentContext.dataModelController];
				[formPopulator populateItemizedTaxForTaxAmtsInfo:taxAdjustmentInfo
						andTaxAmt:[taxAdjustmentInfo.fieldPopulator findItemizedAcctContrib:self.account] 
						andTaxAmtCreator:[[[ItemizedAccountContribTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andAcct:self.account andLabel:tax.name] autorelease]];
			}
			
			[formPopulator nextSectionWithTitle:
					LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_CREDIT_CONTRIBUTIONS_SECTION_HEADER")];
			for(TaxInput *tax in inputs)
			{
				ItemizedTaxAmtsInfo *taxCreditInfo = [ItemizedTaxAmtsInfo taxCreditInfo:tax
					usingDataModelController:parentContext.dataModelController];
				[formPopulator populateItemizedTaxForTaxAmtsInfo:taxCreditInfo
						andTaxAmt:[taxCreditInfo.fieldPopulator findItemizedAcctContrib:self.account] 
						andTaxAmtCreator:[[[ItemizedAccountContribTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andAcct:self.account andLabel:tax.name] autorelease]];				
			}
		}


		if(self.showWithdrawal)
		{
			[formPopulator nextSectionWithTitle:
					LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_TAXABLE_WITHDRAWALS_SECTION_HEADER")];
			for(TaxInput *tax in inputs)
			{
				ItemizedTaxAmtsInfo *taxSourceInfo = [ItemizedTaxAmtsInfo taxSourceInfo:tax
					usingDataModelController:parentContext.dataModelController];
				[formPopulator populateItemizedTaxForTaxAmtsInfo:taxSourceInfo
						andTaxAmt:[taxSourceInfo.fieldPopulator findItemizedAcctWithdrawal:self.account] 
						andTaxAmtCreator:[[[ItemizedAccountWithdrawalTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andAcct:self.account andLabel:tax.name] autorelease]];
			}
		}

		if(self.showInterest)
		{
			[formPopulator nextSectionWithTitle:
					LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_TAXABLE_INTEREST_SECTION_HEADER")];
			for(TaxInput *tax in inputs)
			{
				ItemizedTaxAmtsInfo *taxSourceInfo = [ItemizedTaxAmtsInfo taxSourceInfo:tax
					usingDataModelController:parentContext.dataModelController];
				[formPopulator populateItemizedTaxForTaxAmtsInfo:taxSourceInfo
						andTaxAmt:[taxSourceInfo.fieldPopulator findItemizedAcctInterest:self.account] 
						andTaxAmtCreator:[[[ItemizedAccountTaxAmtCreator alloc] 
					initWithFormContext:parentContext
					andAcct:self.account andLabel:tax.name] autorelease]];
			}
		}


	}

	return formPopulator.formInfo;
	
}


-(void)dealloc
{
	[account release];
	[super dealloc];
}

@end