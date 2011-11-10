//
//  TaxBracket.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxBracket.h"
#import "MultiScenarioGrowthRate.h"
#import "TaxBracketEntry.h"

NSString * const TAX_BRACKET_ENTITY_NAME = @"TaxBracket";

@implementation TaxBracket
@dynamic cutoffGrowthRate;
@dynamic taxBracketEntries;

// Inverse Relationship

// TBD - Do we need shared TaxBrackets? The inverse relationship below is setup such that 
// the tax bracket is ownded by the TaxInput, and is deleted with the TaxInput. We need
// to reconsider if tax brackets can be shared amongst TaxInputs, or we support instantiation
// of common tax brackets, or something else.

@dynamic taxInputTaxBracket;




- (void)addTaxBracketEntriesObject:(TaxBracketEntry *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"taxBracketEntries"] addObject:value];
    [self didChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTaxBracketEntriesObject:(TaxBracketEntry *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"taxBracketEntries"] removeObject:value];
    [self didChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTaxBracketEntries:(NSSet *)value {    
    [self willChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"taxBracketEntries"] unionSet:value];
    [self didChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTaxBracketEntries:(NSSet *)value {
    [self willChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"taxBracketEntries"] minusSet:value];
    [self didChangeValueForKey:@"taxBracketEntries" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
