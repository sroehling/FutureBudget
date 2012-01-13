//
//  ItemizedTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ItemizedTaxAmt;

@protocol ItemizedTaxAmtCreator <NSObject>

- (ItemizedTaxAmt*)createItemizedTaxAmt;
- (NSString*)itemLabel;

@end
