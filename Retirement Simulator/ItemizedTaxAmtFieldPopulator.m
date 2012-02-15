//
//  ItemizedTaxAmtFieldPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtFieldPopulator.h"
#import "ItemizedTaxAmts.h"

#import "IncomeItemizedTaxAmt.h"
#import "ExpenseItemizedTaxAmt.h"
#import "AccountWithdrawalItemizedTaxAmt.h"
#import "AccountContribItemizedTaxAmt.h"
#import "AccountInterestItemizedTaxAmt.h"
#import "AssetGainItemizedTaxAmt.h"
#import "LoanInterestItemizedTaxAmt.h"

#import "DataModelController.h"
#import "IncomeInput.h"
#import "ExpenseInput.h"
#import "Account.h"
#import "AssetInput.h"
#import "LoanInput.h"

@implementation ItemizedTaxAmtFieldPopulator


@synthesize itemizedTaxAmts;
@synthesize dataModelController;

@synthesize itemizedIncomes;
@synthesize itemizedExpenses;
@synthesize itemizedAccountInterest;
@synthesize itemizedAccountContribs;
@synthesize itemizedAccountWithdrawals;
@synthesize itemizedAssets;
@synthesize itemizedLoans;


-(id)initWithDataModelController:(DataModelController*)theDataModelController 
	andItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmts != nil);
		self.itemizedTaxAmts = theItemizedTaxAmts;
		
		// In this case, it's OK to use the singleton data model controller,
		// since this class only works with information in a read-only way.
		self.dataModelController = theDataModelController;
		
		
		self.itemizedIncomes = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedExpenses =  [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAccountInterest = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAccountContribs = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAccountWithdrawals = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAssets = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedLoans = [[[NSMutableArray alloc] init] autorelease];
		
		for(ItemizedTaxAmt *itemizedTaxAmt in self.itemizedTaxAmts.itemizedAmts)
		{
			assert(itemizedTaxAmt != nil);
			[itemizedTaxAmt acceptVisitor:self];
		}

	}
	return self;
}

-(void)visitIncomeItemizedTaxAmt:(IncomeItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedIncomes addObject:itemizedTaxAmt];
}

-(void)visitExpenseItemizedTaxAmt:(ExpenseItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedExpenses addObject:itemizedTaxAmt];
}

-(void)visitAccountInterestItemizedTaxAmt:(AccountInterestItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedAccountInterest addObject:itemizedTaxAmt];
}

-(void)visitAccountContribItemizedTaxAmt:(AccountContribItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedAccountContribs addObject:itemizedTaxAmt];
}

-(void)visitAccountWithdrawalItemizedTaxAmt:(AccountWithdrawalItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedAccountWithdrawals addObject:itemizedTaxAmt];
}

-(void)visitAssetGainItemizedTaxAmt:(AssetGainItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedAssets addObject:itemizedTaxAmt];
}

-(void)visitLoanInterestItemizedTaxAmt:(LoanInterestItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedLoans addObject:itemizedTaxAmt];
}


- (NSArray*)incomesNotAlreadyItemized
{
	NSArray *allIncomes = [self.dataModelController
			fetchSortedObjectsWithEntityName:INCOME_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	NSMutableArray *unItemizedIncomes = [NSMutableArray arrayWithArray:allIncomes];	
		
	for(IncomeItemizedTaxAmt *itemizedIncome in self.itemizedIncomes)
	{
		[unItemizedIncomes removeObject:itemizedIncome.income];
	}
	
	return unItemizedIncomes;
}

- (IncomeItemizedTaxAmt*)findItemizedIncome:(IncomeInput*)income
{
	assert(income != nil);
	for(IncomeItemizedTaxAmt *itemizedIncome in self.itemizedIncomes)
	{
		if(itemizedIncome.income == income)
		{
			return itemizedIncome;
		}	
	}
	return nil;
}

- (NSArray*)expensesNotAlreadyItemized
{
	NSArray *allExpenses = [self.dataModelController
			fetchSortedObjectsWithEntityName:EXPENSE_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];;
	NSMutableArray *unItemizedExpenses = [NSMutableArray arrayWithArray:allExpenses];	
		
	for(ExpenseItemizedTaxAmt *itemizedExpense in self.itemizedExpenses)
	{
		[unItemizedExpenses removeObject:itemizedExpense.expense];
	}
	
	return unItemizedExpenses;
}

- (ExpenseItemizedTaxAmt*)findItemizedExpense:(ExpenseInput*)expense
{
	assert(expense != nil);
	for(ExpenseItemizedTaxAmt *itemizedExpense in self.itemizedExpenses)
	{
		if(itemizedExpense.expense == expense)
		{
			return itemizedExpense;
		}
	}
	return nil;
}

- (NSArray*)acctWithdrawalsNotAlreadyItemized
{
	NSArray *allAccounts = [self.dataModelController
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	NSMutableArray *unItemizedAccounts = [NSMutableArray arrayWithArray:allAccounts];	
		
	for(AccountWithdrawalItemizedTaxAmt *itemizedWithdrawal in self.itemizedAccountWithdrawals)
	{
		[unItemizedAccounts removeObject:itemizedWithdrawal.account];
	}
	
	return unItemizedAccounts;
}

- (AccountWithdrawalItemizedTaxAmt *)findItemizedAcctWithdrawal:(Account*)account
{
	assert(account != nil);
	for(AccountWithdrawalItemizedTaxAmt *itemizedWithdrawal in self.itemizedAccountWithdrawals)
	{
		if(itemizedWithdrawal.account == account)
		{
			return itemizedWithdrawal;
		}
	}
	return nil;
}

- (NSArray*)acctContribsNotAlreadyItemized
{
	NSArray *allAccounts = [self.dataModelController
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	NSMutableArray *unItemizedAccounts = [NSMutableArray arrayWithArray:allAccounts];	
		
	for(AccountContribItemizedTaxAmt *itemizedContrib in self.itemizedAccountContribs)
	{
		[unItemizedAccounts removeObject:itemizedContrib.account];
	}
	
	return unItemizedAccounts;
}

- (AccountContribItemizedTaxAmt *)findItemizedAcctContrib:(Account*)account
{
	assert(account != nil);
	for(AccountContribItemizedTaxAmt *itemizedContrib in self.itemizedAccountContribs)
	{
		if(itemizedContrib.account == account)
		{
			return itemizedContrib;
		}
	}
	return nil;
}

- (NSArray*)acctInterestNotAlreadyItemized
{
	NSArray *allAccounts = [self.dataModelController
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	NSMutableArray *unItemizedAccounts = [NSMutableArray arrayWithArray:allAccounts];	
		
	for(AccountInterestItemizedTaxAmt *itemizedInt in self.itemizedAccountInterest)
	{
		[unItemizedAccounts removeObject:itemizedInt.account];
	}
	
	return unItemizedAccounts;
}

-(AccountInterestItemizedTaxAmt *)findItemizedAcctInterest:(Account*)account
{
	assert(account != nil);
	for(AccountInterestItemizedTaxAmt *itemizedInt in self.itemizedAccountInterest)
	{
		if(itemizedInt.account == account)
		{
			return itemizedInt;
		}
	}
	return nil;
}

- (NSArray*)assetGainsNotAlreadyItemized
{
	NSArray *allAssets = [self.dataModelController
			fetchSortedObjectsWithEntityName:ASSET_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	NSMutableArray *unItemizedAssets = [NSMutableArray arrayWithArray:allAssets];	
		
	for(AssetGainItemizedTaxAmt *itemizedAsset in self.itemizedAssets)
	{
		[unItemizedAssets removeObject:itemizedAsset.asset];
	}
	
	return unItemizedAssets;
}

-(AssetGainItemizedTaxAmt *)findItemizedAssetGain:(AssetInput*)asset
{
	assert(asset != nil);
	for(AssetGainItemizedTaxAmt *itemizedAsset in self.itemizedAssets)
	{
		if(itemizedAsset.asset == asset)
		{
			return itemizedAsset;
		}
	}
	return nil;
}

- (NSArray*)loanInterestNotAlreadyItemized
{
	NSArray *allLoans = [self.dataModelController
			fetchSortedObjectsWithEntityName:LOAN_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	NSMutableArray *unItemizedLoans = [NSMutableArray arrayWithArray:allLoans];	
		
	for(LoanInterestItemizedTaxAmt *itemizedLoan in self.itemizedLoans)
	{
		[unItemizedLoans removeObject:itemizedLoan.loan];
	}
	
	return unItemizedLoans;
}



-(LoanInterestItemizedTaxAmt *)findItemizedLoanInterest:(LoanInput*)loan
{
	assert(loan != nil);
	for(LoanInterestItemizedTaxAmt *itemizedLoan in self.itemizedLoans)
	{
		if(itemizedLoan.loan == loan)
		{
			return itemizedLoan;
		}
	}
	return nil;
}


-(void)dealloc
{
	[itemizedTaxAmts release];
	[dataModelController release];
	
	[itemizedIncomes release];
	[itemizedExpenses release];
	[itemizedAccountInterest release];
	[itemizedAccountContribs release];
	[itemizedAccountWithdrawals release];
	[itemizedAssets release];
	[itemizedLoans release];
	[super dealloc];
}

@end
