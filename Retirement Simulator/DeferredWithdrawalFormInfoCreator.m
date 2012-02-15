//
//  DeferredWithdrawalFormPopulator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeferredWithdrawalFormInfoCreator.h"
#import "InputFormPopulator.h"
#import "LocalizationHelper.h"
#import "Account.h"
#import "SectionInfo.h"
#import "FormContext.h"

@implementation DeferredWithdrawalFormInfoCreator

@synthesize account;
@synthesize isNewAccount;

- (id)initWithAccount:(Account*)theAccount andIsNewAccount:(BOOL)accountIsNew
{
	self = [super init];
	if(self)
	{
		assert(theAccount != nil);
		self.account = theAccount;
		self.isNewAccount = accountIsNew;
	}
	return self;
}

- (id)init
{
	assert(0); // must init with account
	return nil;
}


- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isNewAccount
		andFormContext:parentContext] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_DEFERRED_WITHDRAWALS_FORM_TITLE");
	
	[formPopulator nextSection];
		
	[formPopulator populateMultiScenBoolField:account.deferredWithdrawalsEnabled withLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DEFER_WITHDRAWALS_LABEL")];
	
	[formPopulator populateMultiScenSimDate:account.deferredWithdrawalDate 
		andLabel:LOCALIZED_STR(@"INPUT_ACCOUNT_DEFERRED_WITHDRAW_DATE_FIELD_LABEL") 
		andTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_DEFERRED_WITHDRAW_DATE_TITLE")
		andTableHeader:LOCALIZED_STR(@"INPUT_ACCOUNT__DEFERRED_WITHDRAW_DATE_TABLE_HEADER")
		 andTableSubHeader:[NSString stringWithFormat:
			LOCALIZED_STR(@"INPUT_ACCOUNT_DEFERRED_WITHDRAW_DATE_TABLE_SUBHEADER_FORMAT"),
			self.account.name]];


	return formPopulator.formInfo;
}


- (void)dealloc
{
	[account release];
	[super dealloc];
}


@end
