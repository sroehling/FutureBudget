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

@implementation ItemizedAccountTaxFormInfoCreator

@synthesize account;
@synthesize isForNewObject;


-(id)initWithAcct:(Account*)theAccount andIsForNewObject:(BOOL)forNewObject
{
	self = [super init];
	if(self)
	{
		assert(theAccount != nil);
		self.account = theAccount;
		
		self.isForNewObject = forNewObject;
	}
	return self;
}

-(void)populateItemizedTax:(InputFormPopulator*)formPopulator
	fromItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)itemizedTaxAmtsInfo
	andItemizedTaxAmt:(ItemizedTaxAmt*)itemizedTaxAmt
	andItemizedTaxAmtCreator:(id<ItemizedTaxAmtCreator>)taxAmtCreator
{
	
}

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject
			andParentController:parentController] autorelease];
			
	formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_ACCOUNT_TAXES_TITLE");
	
	NSSet *inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME];
	if([inputs count] > 0)
	{
		
		[formPopulator nextSectionWithTitle:
				LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_DEDUCTABLE_CONTRIBUTIONS_SECTION_HEADER")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxDeductionInfo = [ItemizedTaxAmtsInfo taxDeductionInfo:tax];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxDeductionInfo
					andTaxAmt:[taxDeductionInfo.fieldPopulator findItemizedAcctContrib:self.account] 
					andTaxAmtCreator:[[[ItemizedAccountContribTaxAmtCreator alloc] 
						initWithAcct:self.account andLabel:tax.name] autorelease]];
		}


		[formPopulator nextSectionWithTitle:
				LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_ADJUSTABLE_CONTRIBUTIONS_SECTION_HEADER")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxAdjustmentInfo = [ItemizedTaxAmtsInfo taxAdjustmentInfo:tax];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxAdjustmentInfo
					andTaxAmt:[taxAdjustmentInfo.fieldPopulator findItemizedAcctContrib:self.account] 
					andTaxAmtCreator:[[[ItemizedAccountContribTaxAmtCreator alloc] 
				initWithAcct:self.account andLabel:tax.name] autorelease]];
		}
		
		[formPopulator nextSectionWithTitle:
				LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_CREDIT_CONTRIBUTIONS_SECTION_HEADER")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxCreditInfo = [ItemizedTaxAmtsInfo taxCreditInfo:tax];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxCreditInfo
					andTaxAmt:[taxCreditInfo.fieldPopulator findItemizedAcctContrib:self.account] 
					andTaxAmtCreator:[[[ItemizedAccountContribTaxAmtCreator alloc] 
				initWithAcct:self.account andLabel:tax.name] autorelease]];				
		}


		[formPopulator nextSectionWithTitle:
				LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_TAXABLE_WITHDRAWALS_SECTION_HEADER")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxSourceInfo = [ItemizedTaxAmtsInfo taxSourceInfo:tax];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxSourceInfo
					andTaxAmt:[taxSourceInfo.fieldPopulator findItemizedAcctWithdrawal:self.account] 
					andTaxAmtCreator:[[[ItemizedAccountWithdrawalTaxAmtCreator alloc] 
				initWithAcct:self.account andLabel:tax.name] autorelease]];
		}


		[formPopulator nextSectionWithTitle:
				LOCALIZED_STR(@"INPUT_ACCOUNT_TAXES_TAXABLE_INTEREST_SECTION_HEADER")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxSourceInfo = [ItemizedTaxAmtsInfo taxSourceInfo:tax];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxSourceInfo
					andTaxAmt:[taxSourceInfo.fieldPopulator findItemizedAcctInterest:self.account] 
					andTaxAmtCreator:[[[ItemizedAccountTaxAmtCreator alloc] 
				initWithAcct:self.account andLabel:tax.name] autorelease]];
		}


	}

	return formPopulator.formInfo;
	
}


-(void)dealloc
{
	[super dealloc];
	[account release];
}

@end