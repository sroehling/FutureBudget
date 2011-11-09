//
//  TaxBracketEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxBracketEntry.h"

NSString * const TAX_BRACKET_ENTRY_CUTOFF_AMOUNT_KEY = @"cutoffAmount";
NSString * const TAX_BRACKET_ENTRY_TAX_PERCENT_KEY = @"taxPercent";
NSString * const TAX_BRACKET_ENTRY_ENTITY_NAME = @"TaxBracketEntry";

@implementation TaxBracketEntry

@dynamic cutoffAmount;
@dynamic taxPercent;

// Inverse relationship
@dynamic taxBracketEntries;



@end
