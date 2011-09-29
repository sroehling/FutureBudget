//
//  DeferredWithdrawalFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"

@class Account;
@class ValueSubtitleTableCell;

@interface DeferredWithdrawalFieldEditInfo : NSObject <FieldEditInfo> {
    @private
		Account *account;
		ValueSubtitleTableCell *valueCell;
}

@property(nonatomic,retain) Account *account;
@property(nonatomic,retain) ValueSubtitleTableCell *valueCell;

-(id)initWithAccount:(Account*)theAccount;

@end