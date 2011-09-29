//
//  DeferredWithdrawalFormPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeferredWithdrawalFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "Account.h"
#import "SimDateRuntimeInfo.h"
#import "SimDateFieldEditInfo.h"
#import "SharedAppValues.h"
#import "SectionInfo.h"
#import "MultiScenarioBoolInputValueFieldInfo.h"
#import "BoolFieldEditInfo.h"

@implementation DeferredWithdrawalFormInfoCreator

@synthesize account;

- (id)initWithAccount:(Account*)theAccount
{
	self = [super init];
	if(self)
	{
		assert(theAccount != nil);
		self.account = theAccount;
	}
	return self;
}

- (id)init
{
	assert(0); // must init with account
	return nil;
}


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] init] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_DEFERRED_WITHDRAWALS_FORM_TITLE");
	
	SectionInfo *sectionInfo = [formPopulator nextSection];
 	Scenario *currentScenario = (Scenario*)[SharedAppValues singleton].defaultScenario;
	
	MultiScenarioBoolInputValueFieldInfo *enabledFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithFieldLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DEFER_WITHDRAWALS_LABEL") 
			andFieldPlaceholder:@"n/a" andScenario:currentScenario 
		andInputVal:account.multiScenarioDeferredWithdrawalsEnabled] autorelease];
	BoolFieldEditInfo *enabledFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:enabledFieldInfo] autorelease];
	[sectionInfo addFieldEditInfo:enabledFieldEditInfo];

	
	SimDateRuntimeInfo *deferDateInfo = 
		[SimDateRuntimeInfo createForInput:account andFieldTitleKey:@"INPUT_ACCOUNT_DEFERRED_WITHDRAW_DATE_TITLE" andSubHeaderFormatKey:@"INPUT_ACCOUNT_DEFERRED_WITHDRAW_DATE_SUBHEADER_FORMAT" andSubHeaderFormatKeyNoName:@"INPUT_ACCOUNT_DEFERRED_WITHDRAW_DATE_SUBHEADER_FORMAT_NO_NAME"];
    [sectionInfo addFieldEditInfo:[SimDateFieldEditInfo createForMultiScenarioVal:currentScenario 
			andObject:account andKey:ACCOUNT_MULTI_SCEN_DEFERRED_WITHDRAWAL_DATE_KEY 
			andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DEFERRED_WITHDRAW_DATE_FIELD_LABEL") 
			andDefaultValue:self.account.multiScenarioDeferredWithdrawalDateFixed
			andVarDateRuntimeInfo:deferDateInfo andShowEndDates:FALSE
			andDefaultRelEndDate:nil]];


	return formPopulator.formInfo;
	
}


- (void)dealloc
{
	[super dealloc];
	[account release];
}


@end
