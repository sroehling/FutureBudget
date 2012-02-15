//
//  ItemizedIncomeTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemizedTaxAmtCreator.h"
#import "IncomeInput.h"

@class FormContext;


@interface ItemizedIncomeTaxAmtCreator :  NSObject <ItemizedTaxAmtCreator> {
	@private
		FormContext *formContext;
		IncomeInput *income;
		NSString *label;
}

@property(nonatomic,retain) FormContext *formContext;
@property(nonatomic,retain) IncomeInput *income;
@property(nonatomic,retain) NSString *label;

- (id)initWithFormContext:(FormContext*)theFormContext andIncome:(IncomeInput*)theIncome
	andItemLabel:(NSString*)theItemLabel;

@end


