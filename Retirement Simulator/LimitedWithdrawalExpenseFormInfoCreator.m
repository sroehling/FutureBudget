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


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    FormPopulator *formPopulator = [[[FormPopulator alloc] initWithParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_LIMITED_WITHDRAWAL_SELECTION_FORM_TITLE");


	NSArray *inputs = [[DataModelController theDataModelController]
			fetchSortedObjectsWithEntityName:EXPENSE_INPUT_ENTITY_NAME sortKey:INPUT_NAME_KEY];
	if([inputs count] > 0)
	{
		SectionInfo *sectionInfo = [formPopulator nextSection];
		sectionInfo.title = LOCALIZED_STR(@"INPUT_ACCOUNT_LIMITED_WITHDRAWAL_SECTION_TITLE");
		sectionInfo.subTitle = LOCALIZED_STR(@"INPUT_ACCOUNT_LIMITED_WITHDRAWAL_SECTION_SUBTITLE");
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
	[super dealloc];
	[account  release];
}


@end
