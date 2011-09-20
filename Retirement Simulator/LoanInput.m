//
//  LoanInput.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanInput.h"
#import "MultiScenarioInputValue.h"
#import "LocalizationHelper.h"
#import "InputVisitor.h"
#import "VariableValue.h"

NSString * const LOAN_INPUT_ENTITY_NAME = @"LoanInput";

NSString * const LOAN_INPUT_TAXABLE_INTEREST_KEY = @"taxableInterest";
NSString * const INPUT_LOAN_STARTING_BALANCE_KEY = @"startingBalance";
NSString * const INPUT_LOAN_MULTI_SCEN_EXTRA_PMT_AMT_KEY = @"multiScenarioExtraPmtAmt";

NSString * const LOAN_MULTI_SCEN_ORIG_DATE_KEY = @"multiScenarioOrigDate";
NSString * const INPUT_LOAN_MULTI_SCEN_DOWN_PMT_PERCENT_KEY = @"multiScenarioDownPmtPercent";
NSString * const INPUT_LOAN_MULTI_SCEN_LOAN_COST_AMT_KEY = @"multiScenarioLoanCostAmt";

NSString * const LOAN_INTEREST_RATE_KEY = @"multiScenarioInterestRate";

NSString * const INPUT_LOAN_MULTI_SCEN_EXTRA_PMT_GROWTH_RATE_KEY = @"multiScenarioExtraPmtGrowthRate";
NSString * const INPUT_LOAN_MULTI_SCEN_LOAN_COST_GROWTH_RATE_KEY = @"multiScenarioLoanCostGrowthRate";


@implementation LoanInput

@dynamic taxableInterest; // done
@dynamic startingBalance; // done

@dynamic multiScenarioLoanEnabled;

@dynamic multiScenarioLoanCostAmt; // done
@dynamic multiScenarioLoanCostAmtFixed; // done
@dynamic multiScenarioLoanCostGrowthRate;
@dynamic multiScenarioLoanCostGrowthRateFixed;

@dynamic multiScenarioLoanDuration; // done

@dynamic multiScenarioOrigDate; // done
@dynamic multiScenarioOrigDateFixed; // done

@dynamic multiScenarioInterestRateFixed; // done
@dynamic multiScenarioInterestRate; // done

@dynamic multiScenarioDownPmtEnabled; // done
@dynamic multiScenarioDownPmtPercent; // done
@dynamic multiScenarioDownPmtPercentFixed; // done

@dynamic multiScenarioExtraPmtEnabled; // done
@dynamic multiScenarioExtraPmtAmt; // done
@dynamic multiScenarioExtraPmtAmtFixed; // done
@dynamic multiScenarioExtraPmtFrequency;
@dynamic multiScenarioExtraPmtGrowthRate;
@dynamic multiScenarioExtraPmtGrowthRateFixed;

@dynamic variableExtraPmtAmt;
@dynamic variableLoanCostAmt;

- (void)addVariableExtraPmtAmtObject:(VariableValue *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"variableExtraPmtAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"variableExtraPmtAmt"] addObject:value];
    [self didChangeValueForKey:@"variableExtraPmtAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeVariableExtraPmtAmtObject:(VariableValue *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"variableExtraPmtAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"variableExtraPmtAmt"] removeObject:value];
    [self didChangeValueForKey:@"variableExtraPmtAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addVariableExtraPmtAmt:(NSSet *)value {    
    [self willChangeValueForKey:@"variableExtraPmtAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"variableExtraPmtAmt"] unionSet:value];
    [self didChangeValueForKey:@"variableExtraPmtAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeVariableExtraPmtAmt:(NSSet *)value {
    [self willChangeValueForKey:@"variableExtraPmtAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"variableExtraPmtAmt"] minusSet:value];
    [self didChangeValueForKey:@"variableExtraPmtAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



- (void)addVariableLoanCostAmtObject:(VariableValue *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"variableLoanCostAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"variableLoanCostAmt"] addObject:value];
    [self didChangeValueForKey:@"variableLoanCostAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeVariableLoanCostAmtObject:(VariableValue *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"variableLoanCostAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"variableLoanCostAmt"] removeObject:value];
    [self didChangeValueForKey:@"variableLoanCostAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addVariableLoanCostAmt:(NSSet *)value {    
    [self willChangeValueForKey:@"variableLoanCostAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"variableLoanCostAmt"] unionSet:value];
    [self didChangeValueForKey:@"variableLoanCostAmt" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeVariableLoanCostAmt:(NSSet *)value {
    [self willChangeValueForKey:@"variableLoanCostAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"variableLoanCostAmt"] minusSet:value];
    [self didChangeValueForKey:@"variableLoanCostAmt" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}





-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
	[inputVisitor visitLoan:self];
}


- (NSString*)inlineInputType
{
	return LOCALIZED_STR(@"INPUT_LOAN_INLINE_TITLE");
}

-(NSString*)inputTypeTitle
{
	return LOCALIZED_STR(@"INPUT_LOAN_TITLE");
}


@end
