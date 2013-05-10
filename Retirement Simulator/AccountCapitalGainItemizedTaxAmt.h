//
//  AccountCapitalGainItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/10/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemizedTaxAmt.h"

@class Account;

extern NSString * const ACCOUNT_CAPITAL_GAIN_ITEMIZED_TAX_AMT_ENTITY_NAME;

@interface AccountCapitalGainItemizedTaxAmt : ItemizedTaxAmt

@property (nonatomic, retain) Account *account;

@end
