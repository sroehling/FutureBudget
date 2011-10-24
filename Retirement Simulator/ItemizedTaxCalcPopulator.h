//
//  ItemizedTaxCalcPopulator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemizedTaxAmtVisitor.h"

@class ItemizedTaxAmt;
@class SimParams;
@class ItemizedTaxCalcEntry;

@interface ItemizedTaxCalcPopulator : NSObject <ItemizedTaxAmtVisitor> {
    @private
		SimParams *simParams;
		ItemizedTaxCalcEntry *calcEntry;
}

@property(nonatomic,retain) SimParams *simParams;
@property(nonatomic,retain) ItemizedTaxCalcEntry *calcEntry;

-(id)initWithSimParams:(SimParams*)theSimParams;

-(ItemizedTaxCalcEntry*)populateItemizedTaxCalc:(ItemizedTaxAmt*)itemizedTaxAmt 
	fromSimParams:(SimParams*)theSimParams;

@end
