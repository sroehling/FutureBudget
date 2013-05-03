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
#import "TaxesPaidItemizedTaxAmt.h"
#import "AccountDividendItemizedTaxAmt.h"
#import "LocalizationHelper.h"

#import "DataModelController.h"
#import "IncomeInput.h"
#import "ExpenseInput.h"
#import "Account.h"
#import "AssetInput.h"
#import "LoanInput.h"
#import "TaxInput.h"

@implementation ItemizedTaxAmtFieldPopulator


@synthesize itemizedTaxAmts;
@synthesize dataModelController;

@synthesize itemizedIncomes;
@synthesize itemizedExpenses;
@synthesize itemizedAccountInterest;
@synthesize itemizedAccountDividend;
@synthesize itemizedAccountContribs;
@synthesize itemizedAccountWithdrawals;
@synthesize itemizedAssets;
@synthesize itemizedLoans;
@synthesize itemizedTaxesPaid;


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
		self.itemizedAccountDividend = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAccountContribs = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAccountWithdrawals = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedAssets = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedLoans = [[[NSMutableArray alloc] init] autorelease];
		self.itemizedTaxesPaid = [[[NSMutableArray alloc] init] autorelease];
		
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

-(void)visitAccountDividendItemizedTaxAmt:(AccountDividendItemizedTaxAmt*)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedAccountDividend addObject:itemizedTaxAmt];
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

-(void)visitTaxesPaidItemizedTaxAmt:(TaxesPaidItemizedTaxAmt *)itemizedTaxAmt
{
	assert(itemizedTaxAmt != nil);
	[self.itemizedTaxesPaid addObject:itemizedTaxAmt];
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

- (NSArray*)acctDividendNotAlreadyItemized
{
	NSArray *allAccounts = [self.dataModelController
			fetchSortedObjectsWithEntityName:ACCOUNT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	NSMutableArray *unItemizedAccounts = [NSMutableArray arrayWithArray:allAccounts];	
		
	for(AccountDividendItemizedTaxAmt *itemizedDiv in self.itemizedAccountDividend)
	{
		[unItemizedAccounts removeObject:itemizedDiv.account];
	}
	
	return unItemizedAccounts;
}


-(AccountDividendItemizedTaxAmt *)findItemizedAcctDividend:(Account*)account
{
	assert(account != nil);
	for(AccountDividendItemizedTaxAmt *itemizedDiv in self.itemizedAccountDividend)
	{
		if(itemizedDiv.account == account)
		{
			return itemizedDiv;
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


- (NSArray*)taxesPaidNotAlreadyItemizedExcluding:(TaxInput*)taxToExclude
{
	NSArray *allTaxes = [self.dataModelController
			fetchSortedObjectsWithEntityName:TAX_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	NSMutableArray *unItemizedTaxes = [NSMutableArray arrayWithArray:allTaxes];	
		
	for(TaxesPaidItemizedTaxAmt *itemizedTax in self.itemizedTaxesPaid)
	{
		[unItemizedTaxes removeObject:itemizedTax.tax];
	}
	[unItemizedTaxes removeObject:taxToExclude];
	
	return unItemizedTaxes;
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

-(NSUInteger)enabledItemizationCount:(NSArray*)itemizations
{
	NSUInteger theCount = 0;
	for(ItemizedTaxAmt *itemization in itemizations)
	{
		if([itemization.isEnabled boolValue])
		{
			theCount++;
		}
	}
	return theCount;
}


-(NSString*)itemizationSummary
{
	NSMutableArray *listOfListsOfItemizations =
		[[[NSMutableArray alloc] init] autorelease];

	if([self enabledItemizationCount:self.itemizedIncomes] > 0)
	{
		NSMutableArray *incomeNameList = [[[NSMutableArray alloc] init] autorelease];
		for(IncomeItemizedTaxAmt *itemizedIncome in self.itemizedIncomes)
		{
			if([itemizedIncome.isEnabled boolValue])
			{
				[incomeNameList addObject:itemizedIncome.income.name];
			}
		}
		[listOfListsOfItemizations addObject:[NSString stringWithFormat:@"%@:%@",
			LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_INCOME_TITLE"),
			[incomeNameList componentsJoinedByString:@","]]];
	}
	
	if([self enabledItemizationCount:self.itemizedAccountInterest] > 0)
	{
		NSMutableArray *acctNameList = [[[NSMutableArray alloc] init] autorelease];
		for(AccountInterestItemizedTaxAmt *itemizedInt in self.itemizedAccountInterest)
		{
			if([itemizedInt.isEnabled boolValue])
			{
				[acctNameList addObject:itemizedInt.account.name];
			}
		}
		[listOfListsOfItemizations addObject:[NSString stringWithFormat:@"%@:%@",
			LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ACCT_INTEREST_TITLE"),
			[acctNameList componentsJoinedByString:@","]]];
	}

	
	if([self enabledItemizationCount:self.itemizedAccountDividend] > 0)
	{
		NSMutableArray *acctNameList = [[[NSMutableArray alloc] init] autorelease];
		for(AccountDividendItemizedTaxAmt *itemizedDiv in self.itemizedAccountDividend)
		{
			if([itemizedDiv.isEnabled boolValue])
			{
				[acctNameList addObject:itemizedDiv.account.name];
			}
		}
		[listOfListsOfItemizations addObject:[NSString stringWithFormat:@"%@:%@",
			LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ACCT_DIVIDEND_TITLE"),
			[acctNameList componentsJoinedByString:@","]]];
	}


	if([self enabledItemizationCount:self.itemizedLoans] > 0)
	{
		NSMutableArray *loanNameList = [[[NSMutableArray alloc] init] autorelease];
		for(LoanInterestItemizedTaxAmt *itemizedLoan in self.itemizedLoans)
		{
			if([itemizedLoan.isEnabled boolValue])
			{
				[loanNameList addObject:itemizedLoan.loan.name];
			}
		}
		[listOfListsOfItemizations addObject:[NSString stringWithFormat:@"%@:%@",
			LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_LOAN_INTEREST_TITLE"),
			[loanNameList componentsJoinedByString:@","]]];
	}

	if([self enabledItemizationCount:self.itemizedAssets] > 0)
	{
		NSMutableArray *assetNameList = [[[NSMutableArray alloc] init] autorelease];
		for(AssetGainItemizedTaxAmt *itemizedAsset in self.itemizedAssets)
		{
			if([itemizedAsset.isEnabled boolValue])
			{
				[assetNameList addObject:itemizedAsset.asset.name];
			}
		}
		[listOfListsOfItemizations addObject:[NSString stringWithFormat:@"%@:%@",
			LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ASSET_GAIN_TITLE"),
			[assetNameList componentsJoinedByString:@","]]];
	}
	
	if([self enabledItemizationCount:self.itemizedExpenses] > 0)
	{
		NSMutableArray *expenseNameList = [[[NSMutableArray alloc] init] autorelease];
		for(ExpenseItemizedTaxAmt *itemizedExpense in self.itemizedExpenses)
		{
			if([itemizedExpense.isEnabled boolValue])
			{
				[expenseNameList addObject:itemizedExpense.expense.name];
			}
		}
		[listOfListsOfItemizations addObject:[NSString stringWithFormat:@"%@:%@",
			LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_EXPENSE_TITLE"),
			[expenseNameList componentsJoinedByString:@","]]];
	}
	
	if([self enabledItemizationCount:self.itemizedTaxesPaid] > 0)
	{
		NSMutableArray *taxNameList = [[[NSMutableArray alloc] init] autorelease];
		for(TaxesPaidItemizedTaxAmt *itemizedTax in self.itemizedTaxesPaid)
		{
			if([itemizedTax.isEnabled boolValue])
			{
				[taxNameList addObject:itemizedTax.tax.name];
			}
		}
		[listOfListsOfItemizations addObject:[NSString stringWithFormat:@"%@:%@",
			LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_TAXES_PAID_TITLE"),
			[taxNameList componentsJoinedByString:@","]]];
	}

	if([self enabledItemizationCount:self.itemizedAccountWithdrawals] > 0)
	{
		NSMutableArray *acctNameList = [[[NSMutableArray alloc] init] autorelease];
		for(AccountWithdrawalItemizedTaxAmt *itemizedWithdrawal in self.itemizedAccountWithdrawals)
		{
			if([itemizedWithdrawal.isEnabled boolValue])
			{
				[acctNameList addObject:itemizedWithdrawal.account.name];
			}
		}
		[listOfListsOfItemizations addObject:[NSString stringWithFormat:@"%@:%@",
			LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ACCT_WITHDRAWAL_TITLE"),
			[acctNameList componentsJoinedByString:@","]]];
	}

	if([self enabledItemizationCount:self.itemizedAccountContribs] > 0)
	{
		NSMutableArray *acctNameList = [[[NSMutableArray alloc] init] autorelease];
		for(AccountContribItemizedTaxAmt *itemizedContrib in self.itemizedAccountContribs)
		{
			if([itemizedContrib.isEnabled boolValue])
			{
				[acctNameList addObject:itemizedContrib.account.name];
			}
		}
		[listOfListsOfItemizations addObject:[NSString stringWithFormat:@"%@:%@",
			LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ACCT_CONTRIB_TITLE"),
			[acctNameList componentsJoinedByString:@","]]];
	}

	return [listOfListsOfItemizations componentsJoinedByString:@"  "];
}

-(NSUInteger)itemizationCount
{
	NSUInteger theCount = 0;
	
	theCount += [self enabledItemizationCount:self.itemizedIncomes];
	
	theCount += [self enabledItemizationCount:self.itemizedAccountInterest];
	
	theCount += [self enabledItemizationCount:self.itemizedAccountDividend];

	theCount += [self enabledItemizationCount:self.itemizedLoans];

	theCount += [self enabledItemizationCount:self.itemizedAssets];
	
	theCount += [self enabledItemizationCount:self.itemizedExpenses];
	
	theCount += [self enabledItemizationCount:self.itemizedTaxesPaid];

	theCount += [self enabledItemizationCount:self.itemizedAccountWithdrawals];

	theCount += [self enabledItemizationCount:self.itemizedAccountContribs];
	
	return theCount;
	
	
}

-(NSString*)itemizationCountSummary
{
	NSUInteger theCount = [self itemizationCount];
	if(theCount == 0)
	{
		return LOCALIZED_STR(@"INPUT_TAX_ITEMIZATION_COUNT_NONE");
	}
	else
	{
		return [NSString stringWithFormat:@"%d",theCount];
	}
}


-(void)dealloc
{
	[itemizedTaxAmts release];
	[dataModelController release];
	
	[itemizedIncomes release];
	[itemizedExpenses release];
	[itemizedAccountInterest release];
	[itemizedAccountDividend release];
	[itemizedAccountContribs release];
	[itemizedAccountWithdrawals release];
	[itemizedAssets release];
	[itemizedLoans release];
	[itemizedTaxesPaid release];
	
	[super dealloc];
}

@end
