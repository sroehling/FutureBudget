//
//  IncomeXYPlotDataGenerator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IncomeInput.h"
#import "YearValXYPlotDataGenerator.h"


@interface IncomeXYPlotDataGenerator : NSObject <YearValXYPlotDataGenerator> {
	@private
		IncomeInput *income;
}

@property(nonatomic,retain) IncomeInput *income;

-(id)initWithIncome:(IncomeInput*)theIncome;

@end
