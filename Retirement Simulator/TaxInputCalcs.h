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

@interface TaxInputCalcs : NSObject {
    @private
		NSMutableArray *taxInputCalcs;
}

@property(nonatomic,retain) NSMutableArray *taxInputCalcs;

-(void)addTaxInputCalc:(TaxInputCalc*)theTaxInputCalc;

-(void)updateEffectiveTaxRates:(NSDate*)currentDate;
-(void)processDailyTaxPmts:(DigestEntryProcessingParams*)processingParams;

@end
