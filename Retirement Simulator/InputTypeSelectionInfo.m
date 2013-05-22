//
//  InputTypeSelectionInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputTypeSelectionInfo.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"
#import "DataModelController.h"
#import "SharedAppValues.h"
#import "SavingsAccount.h"
#import "Account.h"
#import "LoanInput.h"
#import "AssetInput.h"
#import "InputCreationHelper.h"
#import "TransferInput.h"
#import "TransferEndpointAcct.h"
#import "CoreDataHelper.h"


@implementation InputTypeSelectionInfo

@synthesize inputLabel;
@synthesize subTitle;
@synthesize imageName;
@synthesize inputCreationHelper;
@synthesize dataModelController;

-(id)initWithInputCreationHelper:(InputCreationHelper*)theHelper 
	andDataModelController:(DataModelController *)theDataModelController
	andLabel:(NSString*)theLabel andSubtitle:(NSString*)theSubTitle
	andImageName:(NSString*)theImageName
{
	self = [super init];
	if(self)
	{
		assert(theHelper != nil);
		self.inputCreationHelper = theHelper;
		
		assert(theDataModelController != nil);
		self.dataModelController = theDataModelController;
		
		self.imageName = theImageName;
		self.inputLabel = theLabel;
		self.subTitle = theSubTitle;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}



-(void)dealloc
{
	[inputCreationHelper release];
	[dataModelController release];
	[inputLabel release];
	[subTitle release];
	[imageName release];
	[super dealloc];
}

-(Input*)createInput
{
    assert(0); // must be overridden
    return nil;
}



-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput
{
	newInput.cashFlowEnabled = [inputCreationHelper 
		multiScenBoolValWithDefault:TRUE];
	
	newInput.amountGrowthRate = [inputCreationHelper multiScenDefaultGrowthRate];
	
	newInput.amount = [inputCreationHelper multiScenAmountWithNoDefaultAndNoInitialVal];
	    
	newInput.startDate = [inputCreationHelper multiScenSimDateWithNoDefaultAndNoInitialVal];
    newInput.endDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
   	
	newInput.eventRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyMonthly];
    
}

-(void)populateAccountInputProperties:(Account*)newInput
{
	
	newInput.iconImageName = ACCOUNT_INPUT_DEFAULT_ICON_NAME;

	newInput.contribEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];

	newInput.contribGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];

	newInput.contribAmount = [inputCreationHelper multiScenAmountWithDefault:0.0];
	
	newInput.contribStartDate = [inputCreationHelper multiScenSimDateWithDefaultToday];
	newInput.contribEndDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
		
	newInput.contribRepeatFrequency = [inputCreationHelper multiScenarioRepeatFrequencyOnce];
	
	// Populate initial priority to one which is lower than all the other ones.
	NSUInteger numAcctsIncludingNewOne =
		[inputCreationHelper.dataModel countObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	newInput.withdrawalPriority = [inputCreationHelper 
		multiScenFixedValWithDefault:(double)numAcctsIncludingNewOne];
	
	newInput.deferredWithdrawalsEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	newInput.deferredWithdrawalDate = [inputCreationHelper multiScenSimDateWithDefaultToday];
    
	newInput.interestRate = [inputCreationHelper multiScenGrowthRateWithNoDefaultAndNoInitialVal];

	newInput.dividendRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	newInput.dividendReinvestPercent = [inputCreationHelper multiScenDivReinvestmentPercWithDefaultSharedVal];
	
	newInput.costBasis = [NSNumber numberWithDouble:0.0];
	
	
	TransferEndpointAcct *acctTransferEndpoint = 
		(TransferEndpointAcct *)[self.dataModelController createDataModelObject:TRANSFER_ENDPOINT_ACCT_ENTITY_NAME];
	acctTransferEndpoint.account = newInput;

}


@end

@implementation ExpenseInputTypeSelectionInfo


-(Input*)createInput
{
	
    ExpenseInput *newInput  = (ExpenseInput*)[self.dataModelController 
		createDataModelObject:EXPENSE_INPUT_ENTITY_NAME];;
  
	newInput.iconImageName = EXPENSE_INPUT_DEFAULT_ICON_NAME;
  
    [self populateCashFlowInputProperties:newInput];  
	    
    return newInput;
}

@end

@implementation IncomeInputTypeSelectionInfo

-(Input*)createInput
{
    IncomeInput *newInput  = (IncomeInput*)[self.dataModelController 
		createDataModelObject:INCOME_INPUT_ENTITY_NAME];
		
	newInput.iconImageName = INCOME_INPUT_DEFAULT_ICON_NAME;
	
    [self populateCashFlowInputProperties:newInput];
        
    return newInput;
  
}

@end


@implementation TransferInputTypeSelectionInfo

-(Input*)createInput
{
    TransferInput *newInput  = (TransferInput*)[self.dataModelController 
		createDataModelObject:TRANSFER_INPUT_ENTITY_NAME];
		
	newInput.iconImageName = TRANSFER_INPUT_DEFAULT_ICON_NAME;
	
    [self populateCashFlowInputProperties:newInput];
        
    return newInput;
  
}

@end



@implementation SavingsAccountTypeSelectionInfo


-(Input*)createInput
{
	SavingsAccount *savingsAcct = (SavingsAccount*)[self.dataModelController 
		createDataModelObject:SAVINGS_ACCOUNT_ENTITY_NAME];
		
	savingsAcct.iconImageName = ACCOUNT_INPUT_DEFAULT_ICON_NAME;
	
	[self populateAccountInputProperties:savingsAcct];
	    
    return savingsAcct;
  
}



@end


@implementation LoanInputTypeSelctionInfo

- (Input*)createInput
{
	LoanInput *newInput  = (LoanInput*)[self.dataModelController 
		createDataModelObject:LOAN_INPUT_ENTITY_NAME];
		
	newInput.iconImageName = LOAN_INPUT_DEFAULT_ICON_NAME;
				
	newInput.loanEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	// Loan Cost
	newInput.loanCost = [inputCreationHelper multiScenAmountWithNoDefaultAndNoInitialVal];
	
		
	newInput.loanDuration = [inputCreationHelper multiScenFixedValWithDefault:DEFAULT_LOAN_DURATION_MONTHS];	
	
	newInput.loanCostGrowthRate = [inputCreationHelper multiScenDefaultGrowthRate];
		
	newInput.origDate = [inputCreationHelper multiScenSimDateWithNoDefaultAndNoInitialVal];

	// Interest
	newInput.interestRate = [inputCreationHelper multiScenGrowthRateWithNoDefaultAndNoInitialVal];
		
	// Down Payment	
		
	newInput.downPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	
	newInput.multiScenarioDownPmtPercentFixed = [inputCreationHelper multiScenFixedValWithDefault:0.0];
	newInput.multiScenarioDownPmtPercent = [inputCreationHelper multiScenInputValueWithDefaultFixedVal:
		newInput.multiScenarioDownPmtPercentFixed];


	// Extra Payments 
	
	newInput.extraPmtEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	
	newInput.extraPmtAmt = [inputCreationHelper multiScenAmountWithDefault:0.0];
	newInput.extraPmtGrowthRate = [inputCreationHelper multiScenGrowthRateWithDefault:0.0];
	
	// TBD - extraPmtFrequency doesn't 
	// have any UI input - Should this change
	newInput.extraPmtFrequency = [inputCreationHelper multiScenarioRepeatFrequencyMonthly];

	newInput.earlyPayoffDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
	
	// Deferred Payments
	
	newInput.deferredPaymentEnabled = [inputCreationHelper multiScenBoolValWithDefault:FALSE];
	newInput.deferredPaymentPayInterest = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	newInput.deferredPaymentSubsizedInterest = [inputCreationHelper multiScenBoolValWithDefault:FALSE];

	newInput.deferredPaymentDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
			
	return newInput;
}

@end


@implementation AssetInputTypeSelectionInfo

- (Input*)createInput
{
	AssetInput *newInput  = (AssetInput*)[self.dataModelController 
		createDataModelObject:ASSET_INPUT_ENTITY_NAME];
		
	newInput.iconImageName = ASSET_INPUT_DEFAULT_ICON_NAME;
	
	newInput.assetEnabled = [inputCreationHelper multiScenBoolValWithDefault:TRUE];
	
	newInput.cost = [inputCreationHelper multiScenAmountWithNoDefaultAndNoInitialVal];

	newInput.apprecRate = [inputCreationHelper multiScenGrowthRateWithNoDefaultAndNoInitialVal];

	newInput.purchaseDate = [inputCreationHelper multiScenSimDateWithNoDefaultAndNoInitialVal];
	
	newInput.saleDate = [inputCreationHelper multiScenSimEndDateWithDefaultNeverEndDate];
			
	return newInput;
}

@end



