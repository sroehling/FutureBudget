//
//  LoanBalXYPlotDataGenerator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YearValXYPlotDataGenerator.h"

@class LoanInput;

@interface LoanBalXYPlotDataGenerator : NSObject <YearValXYPlotDataGenerator> {
    @private
		LoanInput *loan;
}

@property(nonatomic,retain) LoanInput *loan;

-(id)initWithLoan:(LoanInput*)theLoan;

@end
