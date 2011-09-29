//
//  DeferredWithdrawalFormPopulator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class Account;

@interface DeferredWithdrawalFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		Account *account;
}

@property(nonatomic,retain) Account *account;

- (id)initWithAccount:(Account*)theAccount;

@end
