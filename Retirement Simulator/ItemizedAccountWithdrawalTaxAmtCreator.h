//
//  ItemizedAccountWithdrawalTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemizedTaxAmtCreator.h"

@class Account;

@interface ItemizedAccountWithdrawalTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
    @private
		Account *account;
}

@property(nonatomic,retain) Account *account;

- (id)initWithAccount:(Account*)theAccount;

@end
