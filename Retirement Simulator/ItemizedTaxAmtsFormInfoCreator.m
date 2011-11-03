//
//  ItemizedTaxAmtsFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtsFormInfoCreator.h"

#import "InputFormPopulator.h"
#import "ItemizedTaxAmts.h"
#import "ItemizedTaxAmt.h"
#import "LocalizationHelper.h"
#import "ItemizedTaxAmtsInfo.h"
#import "ItemizedTaxAmtObjectAdder.h"
#import "InputFormPopulator.h"
#import "ItemizedTaxAmtFieldPopulator.h"
#import "SharedAppValues.h"
#import "Scenario.h"

#import "IncomeItemizedTaxAmt.h"
#import "IncomeInput.h"

#import "ExpenseInput.h"
#import "ExpenseItemizedTaxAmt.h"

#import "Account.h"
#import "AccountInterestItemizedTaxAmt.h"

#import "Account.h"
#import "AccountContribItemizedTaxAmt.h"
#import "AccountWithdrawalItemizedTaxAmt.h"

#import "AssetInput.h"
#import "AssetGainItemizedTaxAmt.h"

#import "LoanInput.h"
#import "LoanInterestItemizedTaxAmt.h"

@implementation ItemizedTaxAmtsFormInfoCreator

@synthesize itemizedTaxAmtsInfo;
@synthesize isForNewObject;


-(id)initWithItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo
	andIsForNewObject:(BOOL)forNewObject
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmtsInfo != nil);
		self.itemizedTaxAmtsInfo = theItemizedTaxAmtsInfo;
		
		self.isForNewObject = forNewObject;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}



- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject] autorelease];
    
    formPopulator.formInfo.title = self.itemizedTaxAmtsInfo.title;
	formPopulator.formInfo.objectAdder = [[[ItemizedTaxAmtObjectAdder alloc] initWithItemizedTaxAmtsInfo:self.itemizedTaxAmtsInfo] autorelease];

	ItemizedTaxAmtFieldPopulator *fieldPopulator = 
		[[[ItemizedTaxAmtFieldPopulator alloc] initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts] autorelease];
		
	if([fieldPopulator.itemizedIncomes count] > 0)
	{
		[formPopulator nextSection];

		for(IncomeItemizedTaxAmt *itemizedIncome in fieldPopulator.itemizedIncomes )
		{
			[formPopulator populateMultiScenFixedValField:
				itemizedIncome.multiScenarioApplicablePercent 
				andValLabel:itemizedIncome.income.name 
				andPrompt:self.itemizedTaxAmtsInfo.amtPrompt];
		}
	}
	
	if([fieldPopulator.itemizedExpenses count] > 0)
	{
		[formPopulator nextSection];
		
		for(ExpenseItemizedTaxAmt *itemizedExpense in fieldPopulator.itemizedExpenses)
		{
			[formPopulator populateMultiScenFixedValField:
				itemizedExpense.multiScenarioApplicablePercent 
				andValLabel:itemizedExpense.expense.name 
				andPrompt:self.itemizedTaxAmtsInfo.amtPrompt];
		}
	}
	
	if([fieldPopulator.itemizedAccountInterest count] > 0)
	{
		[formPopulator nextSection];
		
		for(AccountInterestItemizedTaxAmt *itemizedSavings in fieldPopulator.itemizedAccountInterest)
		{
			[formPopulator populateMultiScenFixedValField:
				itemizedSavings.multiScenarioApplicablePercent 
				andValLabel:itemizedSavings.account.name 
				andPrompt:self.itemizedTaxAmtsInfo.amtPrompt];
		}
	}
	
	if([fieldPopulator.itemizedAccountContribs  count] > 0)
	{
		[formPopulator nextSection];
		for(AccountContribItemizedTaxAmt *itemizedAccountContrib in 
			fieldPopulator.itemizedAccountContribs)
		{
			[formPopulator populateMultiScenFixedValField:
				itemizedAccountContrib.multiScenarioApplicablePercent 
				andValLabel:itemizedAccountContrib.account.name 
				andPrompt:self.itemizedTaxAmtsInfo.amtPrompt];
		}
		
	}

	if([fieldPopulator.itemizedAccountWithdrawals  count] > 0)
	{
		[formPopulator nextSection];
		for(AccountWithdrawalItemizedTaxAmt *itemizedAccountWithdrawal in 
			fieldPopulator.itemizedAccountWithdrawals)
		{
			[formPopulator populateMultiScenFixedValField:
				itemizedAccountWithdrawal.multiScenarioApplicablePercent 
				andValLabel:itemizedAccountWithdrawal.account.name 
				andPrompt:self.itemizedTaxAmtsInfo.amtPrompt];
		}
		
	}
	
	
	if([fieldPopulator.itemizedAssets  count] > 0)
	{
		[formPopulator nextSection];
		for(AssetGainItemizedTaxAmt *itemizedAssetGain in 
			fieldPopulator.itemizedAssets)
		{
			[formPopulator populateMultiScenFixedValField:
				itemizedAssetGain.multiScenarioApplicablePercent 
				andValLabel:itemizedAssetGain.asset.name 
				andPrompt:self.itemizedTaxAmtsInfo.amtPrompt];
		}
		
	}


	if([fieldPopulator.itemizedLoans  count] > 0)
	{
		[formPopulator nextSection];
		for(LoanInterestItemizedTaxAmt *itemizedLoanInterest in 
			fieldPopulator.itemizedLoans)
		{
			[formPopulator populateMultiScenFixedValField:
				itemizedLoanInterest.multiScenarioApplicablePercent 
				andValLabel:itemizedLoanInterest.loan.name 
				andPrompt:self.itemizedTaxAmtsInfo.amtPrompt];
		}
		
	}


	return formPopulator.formInfo;
	
}

-(void)dealloc
{
	[super dealloc];
	[itemizedTaxAmtsInfo release];
}

@end
