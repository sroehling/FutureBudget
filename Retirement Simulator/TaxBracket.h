//
//  TaxBracket.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const TAX_BRACKET_ENTITY_NAME;

@class MultiScenarioGrowthRate, TaxBracketEntry;
@class TaxInput;

@interface TaxBracket : NSManagedObject {
@private
}
@property (nonatomic, retain) MultiScenarioGrowthRate * cutoffGrowthRate;
@property (nonatomic, retain) NSSet* taxBracketEntries;


// Inverse relationship
@property (nonatomic, retain) TaxInput * taxInputTaxBracket;


- (void)addTaxBracketEntriesObject:(TaxBracketEntry *)value;

@end
