//
//  AccountWithdrawalOrderFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/8/13.
//
//

#import "StaticNavFieldEditInfo.h"

@class AccountWithdrawalOrderInfo;

@interface AccountWithdrawalOrderFieldEditInfo : StaticNavFieldEditInfo
{
	@private
		AccountWithdrawalOrderInfo *accountWithdrawalOrderInfo;;
}


@property(nonatomic,retain) AccountWithdrawalOrderInfo *accountWithdrawalOrderInfo;

-(id)initWithAccountWithdrawalOrderInfo:(AccountWithdrawalOrderInfo*)theAccountWithdrawalOrderInfo
	andCaption:(NSString*)theCaption andSubtitle:(NSString*)theSubtitle;

@end
