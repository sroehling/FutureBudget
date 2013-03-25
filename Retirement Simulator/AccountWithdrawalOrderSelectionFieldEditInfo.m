//
//  AccountWithdrawalFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/8/13.
//
//

#import "AccountWithdrawalOrderSelectionFieldEditInfo.h"
#import "MultiScenarioFixedValueFieldInfo.h"
#import "DataModelController.h"
#import "Scenario.h"
#import "Account.h"
#import "AccountWithdrawalOrderInfo.h"

@implementation AccountWithdrawalOrderSelectionFieldEditInfo

@synthesize accountWithdrawalOrderInfo;

-(void)dealloc
{
	[accountWithdrawalOrderInfo release];
	[super dealloc];
}

-(id)initWithAccountWithdrawalOrderInfo:(AccountWithdrawalOrderInfo*)theAccountWithdrawalOrderInfo
{
	self = [super initWithManagedObj:theAccountWithdrawalOrderInfo.account
				andCaption:theAccountWithdrawalOrderInfo.account.name
				andContent:theAccountWithdrawalOrderInfo.withdrawalOrderCaption];
	if(self)
	{
		self.accountWithdrawalOrderInfo = theAccountWithdrawalOrderInfo;
	}
	return self;
}

-(id)initWithManagedObj:(NSManagedObject *)theFieldObj 
	andCaption:(NSString *)theCaption andContent:(NSString *)theContent
{
	assert(0);
	return nil;
}

-(BOOL)canChangeOrderForObjectAssocWithFieldEditInfo
{
	return TRUE;
}

-(void)updateRowOrder:(NSInteger)newRowOrder
{
	[self.accountWithdrawalOrderInfo  setWithdrawalOrder:newRowOrder];
	[self updateContent:self.accountWithdrawalOrderInfo.withdrawalOrderCaption];
	
}




@end
