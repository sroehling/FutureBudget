//
//  AccountWithdrawalFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/8/13.
//
//

#import "StaticFieldEditInfo.h"
#import "Account.h"

@class AccountWithdrawalOrderInfo;

@interface AccountWithdrawalOrderSelectionFieldEditInfo : StaticFieldEditInfo
{
	@private
		AccountWithdrawalOrderInfo *accountWithdrawalOrderInfo;;
}

-(id)initWithAccountWithdrawalOrderInfo:(AccountWithdrawalOrderInfo*)theAccountWithdrawalOrderInfo;

@property(nonatomic,retain) AccountWithdrawalOrderInfo *accountWithdrawalOrderInfo;

@end
