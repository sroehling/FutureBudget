//
//  ItemizedAccountTaxFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class Account;

@interface ItemizedAccountTaxFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		Account *account;
		BOOL isForNewObject;

}

@property(nonatomic,retain) Account *account;
@property BOOL isForNewObject;

-(id)initWithAcct:(Account*)theAccount andIsForNewObject:(BOOL)forNewObject;

@end
