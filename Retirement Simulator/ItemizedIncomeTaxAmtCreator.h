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
		NSString *label;
}

@property(nonatomic,retain) IncomeInput *income;
@property(nonatomic,retain) NSString *label;

- (id)initWithIncome:(IncomeInput*)theIncome
	andItemLabel:(NSString*)theItemLabel;

@end


