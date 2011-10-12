//
//  ItemizedTaxAmtCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ItemizedTaxAmt;
@class IncomeInput;

@protocol ItemizedTaxAmtCreator <NSObject>

- (ItemizedTaxAmt*)createItemizedTaxAmt;

@end


@interface ItemizedIncomeTaxAmtCreator: NSObject <ItemizedTaxAmtCreator> {
	@private
		IncomeInput *income;
}
@property(nonatomic,retain) IncomeInput *income;
- (id)initWithIncome:(IncomeInput*)theIncome;
@end
