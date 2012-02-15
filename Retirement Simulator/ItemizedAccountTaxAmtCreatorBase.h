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
@class FormContext;

@interface ItemizedAccountTaxAmtCreatorBase : NSObject <ItemizedTaxAmtCreator> {
    @private
		FormContext *formContext;
		Account *account;
		NSString *label;
}

@property(nonatomic,retain) Account *account;
@property(nonatomic,retain) NSString *label;
@property(nonatomic,retain) FormContext *formContext;

- (id)initWithFormContext:(FormContext*)theFormContext
	andAcct:(Account*)theAccount andLabel:(NSString*)theLabel;

@end
