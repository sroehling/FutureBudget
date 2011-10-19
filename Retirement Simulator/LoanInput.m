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
NSString * const INPUT_LOAN_MULTI_SCEN_DOWN_PMT_PERCENT_KEY = @"multiScenarioDownPmtPercent";


@implementation LoanInput

@dynamic taxableInterest; // done
@dynamic startingBalance; // done

@dynamic loanEnabled;

@dynamic loanCostGrowthRate;

@dynamic loanDuration; // done

@dynamic origDate;

@dynamic interestRate; // done

@dynamic downPmtEnabled; // done
@dynamic multiScenarioDownPmtPercent; // done
@dynamic multiScenarioDownPmtPercentFixed; // done

@dynamic extraPmtEnabled; // done

@dynamic extraPmtAmt;
@dynamic loanCost;

@dynamic extraPmtFrequency;

@dynamic extraPmtGrowthRate;



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
