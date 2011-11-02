//
//  LoanInterestItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemizedTaxAmt.h"

@class LoanInput;

extern NSString * const LOAN_INTEREST_ITEMIZED_TAX_AMT_ENTITY_NAME;

@interface LoanInterestItemizedTaxAmt : ItemizedTaxAmt {
@private
}
@property (nonatomic, retain) LoanInput * loan;

@end
