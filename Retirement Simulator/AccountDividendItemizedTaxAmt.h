//
//  AccountDividendItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/2/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemizedTaxAmt.h"

@class Account;

extern NSString * const ACCOUNT_DIVIDEND_ITEMIZED_TAX_AMT_ENTITY_NAME;

@interface AccountDividendItemizedTaxAmt : ItemizedTaxAmt

@property (nonatomic, retain) Account *account;

@end
