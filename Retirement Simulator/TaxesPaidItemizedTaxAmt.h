//
//  TaxesPaidItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemizedTaxAmt.h"

@class TaxInput;

extern NSString * const TAXES_PAID_ITEMIZED_TAX_AMT_ENTITY_NAME;

@interface TaxesPaidItemizedTaxAmt : ItemizedTaxAmt

@property (nonatomic, retain) TaxInput *tax;

@end
