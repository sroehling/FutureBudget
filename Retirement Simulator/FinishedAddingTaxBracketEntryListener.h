//
//  FinishedAddingTaxBracketEntryListener.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FinishedAddingObjectListener.h"

@class TaxBracket;


@interface FinishedAddingTaxBracketEntryListener : NSObject <FinishedAddingObjectListener> {
	@private
		TaxBracket *taxBracket;
}

@property(nonatomic,retain) TaxBracket *taxBracket;

-(id)initWithTaxBracket:(TaxBracket*)theTaxBracket;

@end
