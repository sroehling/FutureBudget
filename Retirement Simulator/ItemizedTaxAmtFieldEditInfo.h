//
//  ItemizedTaxAmtFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"

@class ItemizedTaxAmts;
@class ItemizedTaxAmt;
@class ItemizedTaxAmtsInfo;

#import "ItemizedTaxAmtCreator.h"

@interface ItemizedTaxAmtFieldEditInfo : NSObject <FieldEditInfo> {
    @private
		ItemizedTaxAmts *itemizedTaxAmts;
		id<ItemizedTaxAmtCreator> itemizedTaxAmtCreator;
		ItemizedTaxAmt *itemizedTaxAmt;
		ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;
		BOOL isForNewObject;
}

-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts 
	andItemizedTaxAmtCreator:(id<ItemizedTaxAmtCreator>)theItemizedTaxAmtCreator
	andItemizedTaxAmt:(ItemizedTaxAmt*)theItemizedTaxAmt
	andItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo
	andIsForNewObject:(BOOL)forNewObject;

@property(nonatomic,retain) ItemizedTaxAmts *itemizedTaxAmts;
@property(nonatomic,retain) id<ItemizedTaxAmtCreator> itemizedTaxAmtCreator;
@property(nonatomic,retain) ItemizedTaxAmt *itemizedTaxAmt;
@property(nonatomic,retain) ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;

@end
