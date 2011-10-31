//
//  ItemizedSavingsTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemizedTaxAmtCreator.h"
#import "SavingsAccount.h"

@interface ItemizedSavingsTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
    @private
		SavingsAccount *savingsAcct;
}

@property(nonatomic,retain) SavingsAccount *savingsAcct;

-(id)initWithSavingsAcct:(SavingsAccount*)theSavingsAcct;

@end
