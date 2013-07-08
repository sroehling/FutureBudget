//
//  TaxBracketFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormInfoCreator.h"

@class TaxBracket;

@interface TaxBracketFormInfoCreator : NSObject <FormInfoCreator>  {
    @private
		TaxBracket *taxBracket;
		BOOL isForNewObject;
}

@property(nonatomic,retain) TaxBracket *taxBracket;

-(id)initWithTaxBracket:(TaxBracket *)theTaxBracket andIsForNewObject:(BOOL)bracketIsForNewObject;

@end
