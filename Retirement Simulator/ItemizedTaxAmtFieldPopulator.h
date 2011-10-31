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
		NSMutableArray *itemizedExpenses;
		NSMutableArray *itemizedSavingsInterest;
}


@property(nonatomic,retain) ItemizedTaxAmts *itemizedTaxAmts;

@property(nonatomic,retain) NSMutableArray *itemizedIncomes;
@property(nonatomic,retain) NSMutableArray *itemizedExpenses;
@property(nonatomic,retain) NSMutableArray *itemizedSavingsInterest;


-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts;

@end
