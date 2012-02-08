//
//  ItemizedExpenseTaxFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class ExpenseInput;

@interface ItemizedExpenseTaxFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		ExpenseInput *expense;
		BOOL isForNewObject;

}

@property(nonatomic,retain) ExpenseInput *expense;
@property BOOL isForNewObject;

-(id)initWithExpense:(ExpenseInput*)theExpense andIsForNewObject:(BOOL)forNewObject;

@end
