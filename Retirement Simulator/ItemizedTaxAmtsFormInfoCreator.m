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

#import "SavingsAccount.h"
#import "SavingsInterestItemizedTaxAmt.h"

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
	
	if([fieldPopulator.itemizedSavingsInterest count] > 0)
	{
		[formPopulator nextSection];
		
		for(SavingsInterestItemizedTaxAmt *itemizedSavings in fieldPopulator.itemizedSavingsInterest)
		{
			[formPopulator populateMultiScenFixedValField:
				itemizedSavings.multiScenarioApplicablePercent 
				andValLabel:itemizedSavings.savingsAcct.name 
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
