//
//  AccountContribAmountVariableValueListMgr.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VariableValueListMgr.h"

@class Account;

@interface AccountContribAmountVariableValueListMgr : NSObject <VariableValueListMgr> {
	@private
		Account *account;
}

- (id) initWithAccount:(Account*)theCashFlow;

@property(nonatomic,retain) Account *account;

@end
