//
//  TaxBracketEntryFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class TaxBracketEntry;
@class Scenario;

@interface TaxBracketEntryFormInfoCreator : NSObject  <FormInfoCreator> {
    @private
		TaxBracketEntry *taxBracketEntry;
		BOOL newEntry;
}

@property(nonatomic,retain) TaxBracketEntry *taxBracketEntry;
@property BOOL newEntry;

-(id)initWithTaxBracketEntry:(TaxBracketEntry*)theTaxBracketEntry
		andIsNewEntry:(BOOL)isNewEntry;

@end
