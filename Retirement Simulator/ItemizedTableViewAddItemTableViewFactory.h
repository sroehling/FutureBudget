//
//  ItemizedTableViewAddItemTableViewFactory.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericTableViewFactory.h"

@class ItemizedTaxAmtsInfo;
@class ItemizedTaxAmt;
@protocol ItemizedTaxAmtCreator;

@interface ItemizedTableViewAddItemTableViewFactory : NSObject <GenericTableViewFactory> {
    @private
		ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;
		id<ItemizedTaxAmtCreator> itemizedTaxAmtCreator;
}

-(id)initWithItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo
	andItemizedTaxAmtCreator:(id<ItemizedTaxAmtCreator>)theTaxAmtCreator;

@property(nonatomic,retain) ItemizedTaxAmtsInfo *itemizedTaxAmtsInfo;
@property(nonatomic,retain) id<ItemizedTaxAmtCreator> itemizedTaxAmtCreator;

@end
