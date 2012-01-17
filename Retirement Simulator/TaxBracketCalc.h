//
//  TaxBracketCalc.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaxBracket;

@interface TaxBracketCalc : NSObject {
    @private
		NSArray *taxBracketEntries;
}

@property(nonatomic,retain) NSArray *taxBracketEntries;

-(id)initWithTaxBracket:(TaxBracket*)theTaxBracket;

-(double)calcEffectiveTaxRateForGrossIncome:(double)grossIncome 
	andTaxableIncome:(double)taxableIncome withCredits:(double)creditAmount;

@end
