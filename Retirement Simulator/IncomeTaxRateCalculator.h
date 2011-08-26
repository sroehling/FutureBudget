//
//  IncomeTaxRateCalculator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol IncomeTaxRateCalculator <NSObject>

- (double)taxRateForGrossIncome:(double)incomeAmount andDeductions:(double)deductionAmount;

@end
