//
//  SavingsInterestItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemizedTaxAmt.h"

@class SavingsAccount;

extern NSString * const SAVINGS_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME;

@interface SavingsInterestItemizedTaxAmt : ItemizedTaxAmt {
@private
}
@property (nonatomic, retain) SavingsAccount * savingsAcct;

@end
