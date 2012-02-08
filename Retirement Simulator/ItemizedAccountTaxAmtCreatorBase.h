//
//  ItemizedAccountTaxAmtCreatorBase.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemizedTaxAmtCreator.h"

@class Account;

@interface ItemizedAccountTaxAmtCreatorBase : NSObject <ItemizedTaxAmtCreator> {
    @private
		Account *account;
		NSString *label;
}

@property(nonatomic,retain) Account *account;
@property(nonatomic,retain) NSString *label;

- (id)initWithAcct:(Account*)theAccount andLabel:(NSString*)theLabel;

@end
