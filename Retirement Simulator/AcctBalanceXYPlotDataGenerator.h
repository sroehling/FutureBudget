//
//  AcctBalanceXYPlotDataGenerator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YearValXYPlotDataGenerator.h"
#import "AcctResultGenerator.h"

@class Account;

@interface AcctBalanceXYPlotDataGenerator : AcctResultGenerator <YearValXYPlotDataGenerator> {
}

@end
