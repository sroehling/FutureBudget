//
//  TaxInputCalcCltn.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaxInputCalc;
@class DigestEntryProcessingParams;
@class SimParams;

@interface TaxInputCalcs : NSObject {
    @private
		NSMutableArray *taxInputCalcs;
		NSMutableSet *taxesSimulated;
}

@property(nonatomic,retain) NSMutableArray *taxInputCalcs;
@property(nonatomic,retain) NSMutableSet *taxesSimulated;

-(void)addTaxInputCalc:(TaxInputCalc*)theTaxInputCalc;
-(void)configCalcEntries:(SimParams*)theSimParams;

-(void)updateEffectiveTaxRates:(NSDate*)currentDate
	andLastDayOfTaxYear:(NSDate*)lastDayOfTaxYear;
-(void)processDailyTaxPmts:(DigestEntryProcessingParams*)processingParams;


@end
