//
//  AccountWithdrawalOrderFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/8/13.
//
//

#import "AccountWithdrawalOrderFieldEditInfo.h"
#import "Account.h"
#import "LocalizationHelper.h"
#import "AccountWithdrawalOrderFormInfoCreator.h"
#import "Scenario.h"
#import "DataModelController.h"	
#import "AccountWithdrawalOrderInfo.h"

@implementation AccountWithdrawalOrderFieldEditInfo


@synthesize accountWithdrawalOrderInfo;

-(void)dealloc
{
	[accountWithdrawalOrderInfo release];
	[super dealloc];
}

-(id)initWithAccountWithdrawalOrderInfo:(AccountWithdrawalOrderInfo*)theAccountWithdrawalOrderInfo
	andCaption:(NSString*)theCaption andSubtitle:(NSString*)theSubtitle
{

	AccountWithdrawalOrderFormInfoCreator *withdrawalOrderFormInfoCreator =
		[[[AccountWithdrawalOrderFormInfoCreator alloc]
			initWithInputScenario:theAccountWithdrawalOrderInfo.inputScenario] autorelease];
			
	self = [super initWithCaption:theCaption  andSubtitle:theSubtitle
		andContentDescription:theAccountWithdrawalOrderInfo.withdrawalOrderCaption
		andSubFormInfoCreator:withdrawalOrderFormInfoCreator];
	if(self)
	{
		self.accountWithdrawalOrderInfo = theAccountWithdrawalOrderInfo;
	}
	return self;
}

-(id)init
{
	assert(0);
	return 0;
}

@end
