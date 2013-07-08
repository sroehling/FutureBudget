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
@class InputValDigestSummation;

@interface TaxInputCalc : NSObject {
    @private
		TaxInput *taxInput;
		
		ItemizedTaxCalcEntries *incomeCalcEntries;
		ItemizedTaxCalcEntries *adjustmentCalcEntries;
		ItemizedTaxCalcEntries *deductionCalcEntries;
		ItemizedTaxCalcEntries *creditCalcEntries;

		SimParams *simParams;
		
		InputValDigestSummation *taxesPaid;


		TaxBracketCalc *taxBracketCalc;
		double effectiveTaxRate;
}

@property(nonatomic,retain) TaxInput *taxInput;
@property(nonatomic,retain) TaxBracketCalc *taxBracketCalc;
@property(nonatomic,retain) SimParams *simParams;
@property double effectiveTaxRate;
@property(nonatomic,retain) ItemizedTaxCalcEntries *incomeCalcEntries;
@property(nonatomic,retain) ItemizedTaxCalcEntries *adjustmentCalcEntries;
@property(nonatomic,retain) ItemizedTaxCalcEntries *deductionCalcEntries;
@property(nonatomic,retain) ItemizedTaxCalcEntries *creditCalcEntries;
@property(nonatomic,retain) InputValDigestSummation *taxesPaid;

-(id)initWithTaxInput:(TaxInput*)theTaxInput andSimParams:(SimParams*)theSimParams;
-(void)configTaxCalcEntries:(SimParams*)theSimParams;
-(void)updateEffectiveTaxRate:(NSDate*)currentDate
	andLastDayOfTaxYear:(NSDate*)lastDayOfTaxYear;
-(void)processDailyTaxPmt:(DigestEntryProcessingParams*)processingParams;

@end
