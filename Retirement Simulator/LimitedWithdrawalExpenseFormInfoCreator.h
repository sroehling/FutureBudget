//
//  LimitedWithdrawalExpenseFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"
#import "Account.h"

@interface LimitedWithdrawalExpenseFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		Account *account;
}

@property(nonatomic,retain) Account *account;

-(id)initWithAccount:(Account*)theAccount;

@end
