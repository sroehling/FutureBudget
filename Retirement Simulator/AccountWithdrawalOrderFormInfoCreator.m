//
//  AccountWithdrawalOrderFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/8/13.
//
//

#import "AccountWithdrawalOrderFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "FormContext.h"
#import "DataModelController.h"
#import "Account.h"
#import "AccountWithdrawalOrderSelectionFieldEditInfo.h"
#import "SectionInfo.h"
#import "FormInfo.h"
#import "FormContext.h"
#import "AccountWithdrawalOrderInfo.h"

@implementation AccountWithdrawalOrderFormInfoCreator

@synthesize inputScenario;

-(id)initWithInputScenario:(Scenario*)theScenario
{
	self = [super init];
	if(self)
	{
		assert(theScenario != nil);
		self.inputScenario = theScenario;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] 
		initWithFormContext:parentContext] autorelease];
		
	[formPopulator populateWithHeader:LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_LABEL")
		andSubHeader:LOCALIZED_STR(@"INPUT_ACCOUNT__WITHDRAWAL_PRIORITY_TABLE_SUBTITLE")
		andHelpFile:@"accountWithdrawalPriority" andParentController:parentContext.parentController];
  
	formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_WITHDRAWAL_PRIORITY_LABEL");
  		
	[formPopulator nextSection];
	
	
	// Sort the accounts by their current withdrawal order
	NSArray *sortedWithdrawalOrderInfos = [AccountWithdrawalOrderInfo
			sortedWithdrawalOrderInfos:parentContext.dataModelController
			underScenario:self.inputScenario];
	for(AccountWithdrawalOrderInfo *acctWithOrderInfo in sortedWithdrawalOrderInfos)
	{
		AccountWithdrawalOrderSelectionFieldEditInfo *withdrawalOrderFieldEditInfo
			= [[[AccountWithdrawalOrderSelectionFieldEditInfo alloc]
			initWithAccountWithdrawalOrderInfo:acctWithOrderInfo] autorelease];
		[formPopulator.currentSection addFieldEditInfo:withdrawalOrderFieldEditInfo];
	}
  
	return formPopulator.formInfo;
	
}


@end
