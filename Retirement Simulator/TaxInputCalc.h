//
//  TaxInputCalc.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaxInput;
@class ItemizedTaxCalcEntries;
@class SimParams;
@class TaxBracketCalc;
@class DigestEntryProcessingParams;

@interface TaxInputCalc : NSObject {
    @private
		TaxInput *taxInput;
		ItemizedTaxCalcEntries *incomeCalcEntries;
		TaxBracketCalc *taxBracketCalc;
		double effectiveTaxRate;
}

@property(nonatomic,retain) TaxInput *taxInput;
@property(nonatomic,retain) TaxBracketCalc *taxBracketCalc;
@property double effectiveTaxRate;
@property(nonatomic,retain) ItemizedTaxCalcEntries *incomeCalcEntries;

-(id)initWithTaxInput:(TaxInput*)theTaxInput andSimParams:(SimParams*)theSimParams;
-(void)updateEffectiveTaxRate;
-(void)processDailyTaxPmt:(DigestEntryProcessingParams*)processingParams;

@end
