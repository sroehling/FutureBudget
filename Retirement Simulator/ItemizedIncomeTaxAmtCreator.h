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


@interface ItemizedIncomeTaxAmtCreator :  NSObject <ItemizedTaxAmtCreator> {
	@private
		IncomeInput *income;
}

@property(nonatomic,retain) IncomeInput *income;
- (id)initWithIncome:(IncomeInput*)theIncome;

@end


