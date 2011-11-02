//
//  AccountContribItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemizedTaxAmt.h"

extern NSString * const ACCOUNT_CONTRIB_ITEMIZED_TAX_AMT_ENTITY_NAME;

@class Account;

@interface AccountContribItemizedTaxAmt : ItemizedTaxAmt {
@private
}
@property (nonatomic, retain) Account * account;

@end
