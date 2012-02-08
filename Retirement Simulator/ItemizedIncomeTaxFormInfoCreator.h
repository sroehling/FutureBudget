//
//  ItemizedIncomeTaxFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class IncomeInput;

@interface ItemizedIncomeTaxFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		IncomeInput *income;
		BOOL isForNewObject;
}

-(id)initWithIncome:(IncomeInput*)theIncome andIsForNewObject:(BOOL)forNewObject;

@property(nonatomic,retain) IncomeInput *income;
@property BOOL isForNewObject;

@end
