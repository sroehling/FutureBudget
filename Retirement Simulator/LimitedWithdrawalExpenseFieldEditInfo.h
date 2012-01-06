//
//  LimitedWithdrawalExpenseFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"

@class Account;
@class ExpenseInput;

@interface LimitedWithdrawalExpenseFieldEditInfo : NSObject <FieldEditInfo> {
    @private
		Account *account;
		ExpenseInput *expense;
}

-(id)initWithAccount:(Account*)theAccount andExpense:(ExpenseInput*)theExpense;

@property(nonatomic,retain) Account *account;
@property(nonatomic,retain) ExpenseInput *expense;

@end
