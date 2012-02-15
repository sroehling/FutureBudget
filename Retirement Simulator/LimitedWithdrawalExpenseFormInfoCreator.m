//
//  LimitedWithdrawalExpenseFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LimitedWithdrawalExpenseFormInfoCreator.h"
#import "FormPopulator.h"
#import "LocalizationHelper.h"
#import "ExpenseInput.h"
#import "DataModelController.h"
#import "SectionInfo.h"
#import "LimitedWithdrawalExpenseFieldEditInfo.h"
#import "FormContext.h"


@implementation LimitedWithdrawalExpenseFormInfoCreator

@synthesize account;

-(id)initWithAccount:(Account*)theAccount
{
	self = [super init];
	if(self)
	{	
		assert(theAccount != nil);
		self.account = theAccount;
	}
	return self;
}


- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] 
		initWithFormContext:parentContext] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_LIMITED_WITHDRAWAL_SELECTION_FORM_TITLE");


	NSArray *inputs = [parentContext.dataModelController
			fetchSortedObjectsWithEntityName:EXPENSE_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		SectionInfo *sectionInfo = [formPopulator 
			nextSectionWithTitle:LOCALIZED_STR(@"INPUT_ACCOUNT_LIMITED_WITHDRAWAL_SECTION_TITLE")
			andHelpFile:@"limitedWithdrawal"];
		for(ExpenseInput *expense in inputs)
		{ 
		  
			assert(expense != nil);
			LimitedWithdrawalExpenseFieldEditInfo *fieldEditInfo =
				[[[LimitedWithdrawalExpenseFieldEditInfo alloc] initWithAccount:self.account
					andExpense:expense] autorelease];
			[sectionInfo addFieldEditInfo:fieldEditInfo];

		}
	}


	return formPopulator.formInfo;
	
}




-(void)dealloc
{
	[account  release];
	[super dealloc];
}


@end
