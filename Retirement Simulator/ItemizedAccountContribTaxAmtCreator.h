//
//  ItemizedAccountContribTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

#import "ItemizedTaxAmtCreator.h"

@interface ItemizedAccountContribTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
    @private
		Account *account;
}

@property(nonatomic,retain) Account *account;

- (id)initWithAccount:(Account*)theAccount;

@end
