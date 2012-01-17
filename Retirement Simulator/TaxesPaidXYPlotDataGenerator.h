//
//  TaxesPaidXYPlotDataGenerator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YearValXYPlotDataGenerator.h"

@class TaxInput;

@interface TaxesPaidXYPlotDataGenerator : NSObject <YearValXYPlotDataGenerator> {
    @private
		TaxInput *taxInput;
}

@property(nonatomic,retain) TaxInput *taxInput;

-(id)initWithTax:(TaxInput*)theTax;

@end
