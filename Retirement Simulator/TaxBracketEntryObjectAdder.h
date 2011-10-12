//
//  TaxBracketEntryObjectAdder.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TableViewObjectAdder.h"
#import "TaxBracket.h"

@class TaxBracket;

@interface TaxBracketEntryObjectAdder : NSObject <TableViewObjectAdder>  {
		@private
			TaxBracket *taxBracket;
}

@property(nonatomic,retain) TaxBracket *taxBracket;

-(id)initWithTaxBracket:(TaxBracket*)theTaxBracket;

@end
