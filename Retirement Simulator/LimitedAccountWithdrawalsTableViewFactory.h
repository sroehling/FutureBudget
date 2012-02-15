//
//  LimitedAccountWithdrawalsTableViewFactory.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericTableViewFactory.h"

@class Account;

@interface LimitedAccountWithdrawalsTableViewFactory : NSObject <GenericTableViewFactory> {
	@private
		Account *account;
}

-(id)initWithAccount:(Account*)theAccount;

@property(nonatomic,retain) Account *account;
@end
