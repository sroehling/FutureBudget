//
//  ItemizedTaxAmts.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const ITEMIZED_TAX_AMTS_ENTITY_NAME;

@class ItemizedTaxAmt;
@class TaxInput;

@interface ItemizedTaxAmts : NSManagedObject {
@private
}
@property (nonatomic, retain) NSSet* itemizedAmts;

// Properties for inverse relationships
@property (nonatomic, retain) TaxInput * taxItemizedAdjustments;
@property (nonatomic, retain) TaxInput * taxItemizedCredits;
@property (nonatomic, retain) TaxInput * taxItemizedDeductions;
@property (nonatomic, retain) TaxInput * taxItemizedIncomeSources;


- (void)addItemizedAmtsObject:(ItemizedTaxAmt *)value;
- (void)removeItemizedAmtsObject:(ItemizedTaxAmt *)value;

@end
