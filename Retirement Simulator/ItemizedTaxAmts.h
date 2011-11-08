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

@interface ItemizedTaxAmts : NSManagedObject {
@private
}
@property (nonatomic, retain) NSSet* itemizedAmts;

- (void)addItemizedAmtsObject:(ItemizedTaxAmt *)value;

@end
