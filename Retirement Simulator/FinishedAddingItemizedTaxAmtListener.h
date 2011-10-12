//
//  FinishedAddingItemizedTaxAmtListener.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FinishedAddingObjectListener.h"
#import "ItemizedTaxAmts.h"

@interface FinishedAddingItemizedTaxAmtListener : NSObject <FinishedAddingObjectListener> {
    @private
		ItemizedTaxAmts *itemizedTaxAmts;
}

@property(nonatomic,retain) ItemizedTaxAmts *itemizedTaxAmts;

-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts;

@end
