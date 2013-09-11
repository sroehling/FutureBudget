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
#import "SimResults.h"
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
#import "CashFlowXYPlotDataGenerator.h"
#import "DeficitBalXYPlotDataGenerator.h"
#import "AllAcctContribXYPlotDataGenerator.h"
#import "AcctContribXYPlotGenerator.h"
#import "AcctWithdrawalXYPlotDataGenerator.h"
#import "AllAcctWithdrawalXYPlotDataGenerator.h"
#import "AllTaxesPaidXYPlotDataGenerator.h"
#import "TaxesPaidXYPlotDataGenerator.h"
#import "TaxInput.h"
#import "FormContext.h"
#import "YearValXYPlotDataGenerator.h"
#import "CumulativeCashFlowXYPlotDataGenerator.h"
#import "RelativeNetWorthXYPlotDataGenerator.h"
#import "TotalDebtXYPlotDataGenerator.h"

#import "MBProgressHUD.h"

@implementation ResultsListFormInfoCreator

@synthesize simProgressHUD;
@synthesize simResultsCompleteDelegate;

-(id)init
{
	self = [super init];
	if(self)
	{
	}
	return self;
}

-(BOOL)needsToPreprocessFormData
{
    // TODO - Need to trigger results generation from the SimResultsController
	if([SimResultsController theSimResultsController].resultsOutOfDate)
	{
		return TRUE;
	}
	else 
	{
		return FALSE;
	}
}

-(void)preprocessFormData:(FormContext*)parentContext 
	withProgressCompletionDelegate:(id<ProgressCompleteDelegate>)preprocessingCompleteDelegate;
{
	self.simProgressHUD = [[[MBProgressHUD alloc] 
			initWithView:parentContext.parentController.navigationController.view] autorelease];
	self.simResultsCompleteDelegate = preprocessingCompleteDelegate;

	[parentContext.parentController.navigationController.view addSubview:self.simProgressHUD];
	
	self.simProgressHUD.dimBackground = YES;
	self.simProgressHUD.mode = MBProgressHUDModeDeterminate;
	
	self.simProgressHUD.labelText = LOCALIZED_STR(@"RESULTS_PROGRESS_LABEL");
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	self.simProgressHUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	[self.simProgressHUD showWhileExecuting:@selector(runSimulatorForResults:) 
			onTarget:[SimResultsController theSimResultsController] withObject:self animated:YES];
}

-(void)populateXYPlotDataResults:(FormPopulator*)formPopulator
	andPlotDataGenerator:(id<YearValXYPlotDataGenerator>)plotDataGen
	andResultsTitle:(NSString*)title andResultsSubtitle:(NSString*)subTitle
{
	ResultsViewInfo *resultsViewInfo = [[[ResultsViewInfo alloc]
		initWithSimResultsController:[SimResultsController theSimResultsController]
		andViewTitle:title] autorelease];

	ResultsViewFactory *resultsViewFactory =
		[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:resultsViewInfo
			andPlotDataGenerator:plotDataGen] autorelease];
			
	StaticNavFieldEditInfo *resultsFieldEditInfo =
		[[[StaticNavFieldEditInfo alloc] 
			initWithCaption:title
			andSubtitle:subTitle
			andContentDescription:nil
			andSubViewFactory:resultsViewFactory] autorelease];
			
	[formPopulator.currentSection addFieldEditInfo:resultsFieldEditInfo];
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{

    FormPopulator *formPopulator = [[[FormPopulator alloc] 
		initWithFormContext:parentContext] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"RESULTS_NAV_CONTROLLER_BUTTON_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_SUMMARY_SECTION_TITLE");
	
	SimResultsController *simResultsController = [SimResultsController theSimResultsController];
    
    // TODO - Need to rethink how we hold onto the simResults and
    // verify the results are current
    assert(!simResultsController.resultsOutOfDate);
    SimResults *simResults = simResultsController.currentSimResults;
    [[simResults retain] autorelease];
    assert(simResults != nil);
    
	
	if(true)
	{
		ResultsViewInfo *netWorthViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:simResultsController
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

		[self populateXYPlotDataResults:formPopulator
			andPlotDataGenerator:[[[RelativeNetWorthXYPlotDataGenerator alloc] init] autorelease]
			andResultsTitle:LOCALIZED_STR(@"RESULTS_SUMMARY_RELATIVE_NET_WORTH_TITLE")
			andResultsSubtitle:LOCALIZED_STR(@"RESULTS_SUMMARY_RELATIVE_NET_WORTH_SUBTITLE")];

		[self populateXYPlotDataResults:formPopulator
			andPlotDataGenerator:[[[CashFlowXYPlotDataGenerator alloc] init] autorelease]
			andResultsTitle:LOCALIZED_STR(@"RESULTS_SUMMARY_CASH_FLOW_TITLE")
			andResultsSubtitle:LOCALIZED_STR(@"RESULTS_SUMMARY_CASH_FLOW_SUBTITLE")];

		[self populateXYPlotDataResults:formPopulator
			andPlotDataGenerator:[[[CumulativeCashFlowXYPlotDataGenerator alloc] init] autorelease]
			andResultsTitle:LOCALIZED_STR(@"RESULTS_SUMMARY_CUMULATIVE_CASH_FLOW_TITLE")
			andResultsSubtitle:LOCALIZED_STR(@"RESULTS_SUMMARY_CUMULATIVE_CASH_FLOW_SUBTITLE")];


		ResultsViewInfo *cashBalViewInfo = [[[ResultsViewInfo alloc]
			initWithSimResultsController:simResultsController 
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
        
        [self populateXYPlotDataResults:formPopulator
                   andPlotDataGenerator:[[[TotalDebtXYPlotDataGenerator alloc] init] autorelease]
                        andResultsTitle:LOCALIZED_STR(@"RESULTS_SUMMARY_TOTAL_DEBT_TITLE")
                     andResultsSubtitle:LOCALIZED_STR(@"RESULTS_SUMMARY_TOTAL_DEBT_SUBTITLE")];

		ResultsViewInfo *deficitBalViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:simResultsController 
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


	}

	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_INCOME_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allIncomeViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:simResultsController 
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
		
		for(IncomeInput *income in simResults.incomesSimulated)
		{
			ResultsViewInfo *incomeViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:simResultsController 
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
			initWithSimResultsController:simResultsController 
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
		
		for(ExpenseInput *expense in simResults.expensesSimulated)
		{
			ResultsViewInfo *expenseViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:simResultsController 
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

	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_ASSET_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allAssetsViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:simResultsController 
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
		
		
		
		for(AssetInput *asset in simResults.assetsSimulated)
		{
			ResultsViewInfo *assetViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:simResultsController 
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
			initWithSimResultsController:simResultsController 
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
		
		
		for(LoanInput *loan in simResults.loansSimulated)
		{
			ResultsViewInfo *loanViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:simResultsController 
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
			initWithSimResultsController:simResultsController 
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
		
		for(Account *acct in simResults.acctsSimulated)
		{
			ResultsViewInfo *acctViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:simResultsController 
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
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_ACCT_CONTRIB_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allAcctContribViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_TITLE")] autorelease];
		ResultsViewFactory *allAcctContribViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:allAcctContribViewInfo
				andPlotDataGenerator:[[[AllAcctContribXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *allAcctContribFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_CONTRIB_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:allAcctContribViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:allAcctContribFieldEditInfo];
		
		for(Account *acct in simResults.acctsSimulated)
		{
			ResultsViewInfo *acctContribViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:simResultsController 
				andViewTitle:acct.name] autorelease];
			ResultsViewFactory *acctContribViewFactory = 
				[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:acctContribViewInfo
					andPlotDataGenerator:[[[AcctContribXYPlotGenerator alloc]
					initWithAccount:acct]autorelease]] autorelease];
			StaticNavFieldEditInfo *acctContribFieldEditInfo = 
				[[[StaticNavFieldEditInfo alloc] 
					initWithCaption:acct.name
					andSubtitle:@"" 
					andContentDescription:nil
					andSubViewFactory:acctContribViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:acctContribFieldEditInfo];
		}
	}


	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_ACCT_WITHDRAW_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allAcctWithdrawViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_TITLE")] autorelease];
		ResultsViewFactory *allAcctWithdrawViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:allAcctWithdrawViewInfo
				andPlotDataGenerator:[[[AllAcctWithdrawalXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *allAcctWithdrawFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_ACCT_ALL_ACCT_WITHDRAW_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:allAcctWithdrawViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:allAcctWithdrawFieldEditInfo];
		
		for(Account *acct in simResults.acctsSimulated)
		{
			ResultsViewInfo *acctWithdrawViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:simResultsController 
				andViewTitle:acct.name] autorelease];
			ResultsViewFactory *acctWithdrawViewFactory = 
				[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:acctWithdrawViewInfo
					andPlotDataGenerator:[[[AcctWithdrawalXYPlotDataGenerator alloc]
					initWithAccount:acct]autorelease]] autorelease];
			StaticNavFieldEditInfo *acctWithdrawFieldEditInfo = 
				[[[StaticNavFieldEditInfo alloc] 
					initWithCaption:acct.name
					andSubtitle:@"" 
					andContentDescription:nil
					andSubViewFactory:acctWithdrawViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:acctWithdrawFieldEditInfo];
		}
	}



	

	sectionInfo = [formPopulator nextSection];
	sectionInfo.title = LOCALIZED_STR(@"RESULTS_TAXES_SECTION_TITLE");
	if(true)
	{
		ResultsViewInfo *allTaxesViewInfo = [[[ResultsViewInfo alloc] 
			initWithSimResultsController:simResultsController 
			andViewTitle:LOCALIZED_STR(@"RESULTS_TAXES_ALL_TAXES_TITLE")] autorelease];
		ResultsViewFactory *allTaxesViewFactory = 
			[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:allTaxesViewInfo
				andPlotDataGenerator:[[[AllTaxesPaidXYPlotDataGenerator alloc]init]autorelease]] autorelease];
		StaticNavFieldEditInfo *allTaxesFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] 
				initWithCaption:LOCALIZED_STR(@"RESULTS_TAXES_ALL_TAXES_TITLE")
				andSubtitle:LOCALIZED_STR(@"RESULTS_TAXES_ALL_TAXES_SUBTITLE") 
				andContentDescription:nil
				andSubViewFactory:allTaxesViewFactory] autorelease];
		[sectionInfo addFieldEditInfo:allTaxesFieldEditInfo];
		
		for(TaxInput *tax in simResults.taxesSimulated)
		{
			ResultsViewInfo *taxViewInfo = [[[ResultsViewInfo alloc] 
				initWithSimResultsController:simResultsController 
				andViewTitle:tax.name] autorelease];
			ResultsViewFactory *taxViewFactory = 
				[[[YearValXYPlotResultsViewFactory alloc] initWithResultsViewInfo:taxViewInfo
					andPlotDataGenerator:[[[TaxesPaidXYPlotDataGenerator alloc]
					initWithTax:tax]autorelease]] autorelease];
			StaticNavFieldEditInfo *taxFieldEditInfo = 
				[[[StaticNavFieldEditInfo alloc] 
					initWithCaption:tax.name
					andSubtitle:@"" 
					andContentDescription:nil
					andSubViewFactory:taxViewFactory] autorelease];
			[sectionInfo addFieldEditInfo:taxFieldEditInfo];
		}
	}
	
	return formPopulator.formInfo;
	
}

-(void)dealloc
{
	[simProgressHUD release];
	[super dealloc];
}

- (void)updateProgress:(CGFloat)currentProgress
{
	assert(self.simProgressHUD != nil);
	self.simProgressHUD.progress = currentProgress;
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	
	if(self.simResultsCompleteDelegate != nil)
	{
		[self.simResultsCompleteDelegate progressComplete];
	}
}




@end
