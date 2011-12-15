//
//  ResultsListFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsListFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "SectionInfo.h"
#import "StaticNavFieldEditInfo.h"
#import "ResultsViewFactory.h"
#import "SimResultsController.h"
#import "ResultsViewInfo.h"
#import "YearValXYPlotResultsViewFactory.h"
#import "NetWorthXYPlotDataGenerator.h"
#import "AllAssetValueXYPlotDataGenerator.h"
#import "AssetValueXYPlotDataGenerator.h"
#import "AssetInput.h"
#import "AllLoanBalanceXYPlotDataGenerator.h"
#import "LoanBalXYPlotDataGenerator.h"
#import "LoanInput.h"
#import "AllAcctBalanceXYPlotDataGenerator.h"
#import "AcctBalanceXYPlotDataGenerator.h"
#import "Account.h"
#import "AllIncomeXYPlotDataGenerator.h"
#import "IncomeXYPlotDataGenerator.h"
#import "IncomeInput.h"
#import "AllExpenseXYPlotDataGenerator.h"
#import "ExpenseXYPlotDataGenerator.h"
#import "ExpenseInput.h"

#import "CashBalXYPlotDataGenerator.h"
#import "DeficitBalXYPlotDataGenerator.h"


@implementation ResultsListFormInfoCreator

@synthesize simResultsController;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.simResultsController = [[[SimResultsController alloc] init] autorelease];
	}
	return self;
}

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{

	[self.simResultsController runSimulatorForResults];

    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"RESULTS_NAV_CONTROLLER_BUTTON_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_SUMMARY_SECTION_TITLE");
	
	if(true)
	{
		ResultsViewInfo *netWorthViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:self.simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_SUMMARY_NET_WORTH_TITLE")] autorelease];
		ResultsViewFactory *netWorthViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:netWorthViewInfo
				andPlotDataGenerator:[[[NetWorthXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *netWorthFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_SUMMARY_NET_WORTH_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_SUMMARY_NET_WORTH_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:netWorthViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:netWorthFieldEditInfo];		
	}


	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_ASSET_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allAssetsViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:self.simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_ASSET_ALL_ASSET_TITLE")] autorelease];
		ResultsViewFactory *allAssetsViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:allAssetsViewInfo
				andPlotDataGenerator:[[[AllAssetValueXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *allAssetsFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_ASSET_ALL_ASSET_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_ASSET_ALL_ASSET_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:allAssetsViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:allAssetsFieldEditInfo];
		
		ResultsViewInfo *cashBalViewInfo = [[[ResultsViewInfo alloc]
			initWithSimResultsController:self.simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_CASH_BALANCE_TITLE")] autorelease];
		ResultsViewFactory *cashBalViewFactory =
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:cashBalViewInfo
				andPlotDataGenerator:[[[CashBalXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *cashBalFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_CASH_BALANCE_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_CASH_BALANCE_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:cashBalViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:cashBalFieldEditInfo];
		
		
		for(AssetInput *asset in self.simResultsController.assetsSimulated)
		{
			ResultsViewInfo *assetViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:self.simResultsController 
				andViewTitle:asset.name] autorelease];
			ResultsViewFactory *assetViewFactory = 
				[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:assetViewInfo
					andPlotDataGenerator:[[[AssetValueXYPlotDataGenerator alloc]initWithAsset:asset]autorelease]] autorelease];
			StaticNavFieldEditInfo *assetFieldEditInfo = 
				[[[StaticNavFieldEditInfo alloc] 
					initWithCaption:asset.name
					andSubtitle:@"" 
					andContentDescription:nil
					andSubViewFactory:assetViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:assetFieldEditInfo];
		}
	}
	
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_LOAN_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allLoanViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:self.simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_LOAN_ALL_LOAN_TITLE")] autorelease];
		ResultsViewFactory *allLoanViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:allLoanViewInfo
				andPlotDataGenerator:[[[AllLoanBalanceXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *allLoanFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_LOAN_ALL_LOAN_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_LOAN_ALL_LOAN_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:allLoanViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:allLoanFieldEditInfo];
		
		ResultsViewInfo *deficitBalViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:self.simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_DEFICIT_BALANCE_TITLE")] autorelease];
		ResultsViewFactory *deficitBalViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:deficitBalViewInfo
				andPlotDataGenerator:[[[DeficitBalXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *deficitBalFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_DEFICIT_BALANCE_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_DEFICIT_BALANCE_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:deficitBalViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:deficitBalFieldEditInfo];
		
		for(LoanInput *loan in self.simResultsController.loansSimulated)
		{
			ResultsViewInfo *loanViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:self.simResultsController 
				andViewTitle:loan.name] autorelease];
			ResultsViewFactory *loanViewFactory = 
				[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:loanViewInfo
					andPlotDataGenerator:[[[LoanBalXYPlotDataGenerator alloc]initWithLoan:loan]autorelease]] autorelease];
			StaticNavFieldEditInfo *loanFieldEditInfo = 
				[[[StaticNavFieldEditInfo alloc] 
					initWithCaption:loan.name
					andSubtitle:@"" 
					andContentDescription:nil
					andSubViewFactory:loanViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:loanFieldEditInfo];
		}
	}


	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_ACCT_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allAcctViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:self.simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_TITLE")] autorelease];
		ResultsViewFactory *allAcctViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:allAcctViewInfo
				andPlotDataGenerator:[[[AllAcctBalanceXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *allAcctFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:allAcctViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:allAcctFieldEditInfo];
		
		for(Account *acct in self.simResultsController.acctsSimulated)
		{
			ResultsViewInfo *acctViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:self.simResultsController 
				andViewTitle:acct.name] autorelease];
			ResultsViewFactory *acctViewFactory = 
				[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:acctViewInfo
					andPlotDataGenerator:[[[AcctBalanceXYPlotDataGenerator alloc]
					initWithAccount:acct]autorelease]] autorelease];
			StaticNavFieldEditInfo *acctFieldEditInfo = 
				[[[StaticNavFieldEditInfo alloc] 
					initWithCaption:acct.name
					andSubtitle:@"" 
					andContentDescription:nil
					andSubViewFactory:acctViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:acctFieldEditInfo];
		}
	}
	
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_INCOME_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allIncomeViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:self.simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_INCOME_ALL_INCOME_TITLE")] autorelease];
		ResultsViewFactory *allAcctViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:allIncomeViewInfo
				andPlotDataGenerator:[[[AllIncomeXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *allIncomeFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_INCOME_ALL_INCOME_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_INCOME_ALL_INCOME_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:allAcctViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:allIncomeFieldEditInfo];
		
		for(IncomeInput *income in self.simResultsController.incomesSimulated)
		{
			ResultsViewInfo *incomeViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:self.simResultsController 
				andViewTitle:income.name] autorelease];
			ResultsViewFactory *incomeViewFactory = 
				[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:incomeViewInfo
					andPlotDataGenerator:[[[IncomeXYPlotDataGenerator alloc]
					initWithIncome:income]autorelease]] autorelease];
			StaticNavFieldEditInfo *incomeFieldEditInfo = 
				[[[StaticNavFieldEditInfo alloc] 
					initWithCaption:income.name
					andSubtitle:@"" 
					andContentDescription:nil
					andSubViewFactory:incomeViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:incomeFieldEditInfo];
		}
	}
	
	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_EXPENSE_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allExpenseViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:self.simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_EXPENSE_ALL_EXPENSE_TITLE")] autorelease];
		ResultsViewFactory *allExpenseViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:allExpenseViewInfo
				andPlotDataGenerator:[[[AllExpenseXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *allExpenseFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_EXPENSE_ALL_EXPENSE_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_EXPENSE_ALL_EXPENSE_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:allExpenseViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:allExpenseFieldEditInfo];
		
		for(ExpenseInput *expense in self.simResultsController.expensesSimulated)
		{
			ResultsViewInfo *expenseViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:self.simResultsController 
				andViewTitle:expense.name] autorelease];
			ResultsViewFactory *expenseViewFactory = 
				[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:expenseViewInfo
					andPlotDataGenerator:[[[ExpenseXYPlotDataGenerator alloc]
					initWithExpense:expense]autorelease]] autorelease];
			StaticNavFieldEditInfo *expenseFieldEditInfo = 
				[[[StaticNavFieldEditInfo alloc] 
					initWithCaption:expense.name
					andSubtitle:@"" 
					andContentDescription:nil
					andSubViewFactory:expenseViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:expenseFieldEditInfo];
		}
	}

	
	return formPopulator.formInfo;
	
}

-(void)dealloc
{
	[super dealloc];
	[simResultsController release];
}


@end
