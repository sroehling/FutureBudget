//
//  ItemizedTaxAmtFieldPopulator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemizedTaxAmtVisitor.h"

@class ItemizedTaxAmts;

@interface ItemizedTaxAmtFieldPopulator : NSObject <ItemizedTaxAmtVisitor> {
	@private
		ItemizedTaxAmts *itemizedTaxAmts;
		NSMutableArray *itemizedIncomes;
}

@property(nonatomic,retain) NSMutableArray *itemizedIncomes;
@property(nonatomic,retain) ItemizedTaxAmts *itemizedTaxAmts;

-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts;

@end
