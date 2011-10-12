//
//  IncomeItemizedTaxAmt.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ItemizedTaxAmt.h"

@class IncomeInput;

extern NSString * const INCOME_ITEMIZED_TAX_AMT_ENTITY_NAME;

@interface IncomeItemizedTaxAmt : ItemizedTaxAmt {
@private
}
@property (nonatomic, retain) IncomeInput * income;

@end
