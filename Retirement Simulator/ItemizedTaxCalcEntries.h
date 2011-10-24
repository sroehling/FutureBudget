//
//  ItemizedTaxCalcEntries.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemizedTaxAmts;
@class SimParams;

@interface ItemizedTaxCalcEntries : NSObject {
    @private
		NSMutableArray *calcEntries;
}

@property(nonatomic,retain) NSMutableArray *calcEntries;

-(id)initWithSimParams:(SimParams*)simParams andItemizedTaxAmts:(ItemizedTaxAmts*)itemizedTaxAmts;
-(double)calcTotalItemizedTaxAmt;

@end
