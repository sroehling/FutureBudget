//
//  ItemizedSavingsTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemizedTaxAmtCreator.h"
#import "Account.h"

@interface ItemizedAccountTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
    @private
		Account *account;
}

@property(nonatomic,retain) Account *account;


-(id)initWithAcct:(Account*)theAcct;

@end
