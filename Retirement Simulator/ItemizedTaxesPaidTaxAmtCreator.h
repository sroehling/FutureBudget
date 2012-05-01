//
//  ItemizedTaxesPaidTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemizedTaxAmtCreator.h"

@class FormContext;
@class TaxInput;

@interface ItemizedTaxesPaidTaxAmtCreator : NSObject <ItemizedTaxAmtCreator> {
    @private
		FormContext *formContext;
		TaxInput *tax;
		NSString *label;
}

@property(nonatomic,retain) TaxInput *tax;
@property(nonatomic,retain) NSString *label;
@property(nonatomic,retain) FormContext *formContext;

-(id)initWithFormContext:(FormContext*)theFormContext
	andTax:(TaxInput*)theTax andLabel:(NSString*)theLabel;

@end
