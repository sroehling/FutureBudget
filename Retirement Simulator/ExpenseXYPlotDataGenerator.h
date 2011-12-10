//
//  ExpenseXYPlotDataGenerator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YearValXYPlotDataGenerator.h"

@class ExpenseInput;

@interface ExpenseXYPlotDataGenerator : NSObject <YearValXYPlotDataGenerator> {
    @private
		ExpenseInput *expense;
}

@property(nonatomic,retain) ExpenseInput *expense;

-(id)initWithExpense:(ExpenseInput*)theExpense;

@end
