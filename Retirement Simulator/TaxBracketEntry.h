//
//  TaxBracketEntry.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const TAX_BRACKET_ENTRY_CUTOFF_AMOUNT_KEY;
extern NSString * const TAX_BRACKET_ENTRY_TAX_PERCENT_KEY;
extern NSString * const TAX_BRACKET_ENTRY_ENTITY_NAME;

@class TaxBracket;

@interface TaxBracketEntry : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * cutoffAmount;
@property (nonatomic, retain) NSNumber * taxPercent;

@property (nonatomic, retain) TaxBracket * taxBracketEntries;


@end
