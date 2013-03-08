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
#import "LoanInterestItemizedTaxAmt.h"
#import "MultiScenarioSimEndDate.h"
#import "SimInputHelper.h"
#import "MultiScenarioSimDate.h"
#import "DateHelper.h"

NSString * const LOAN_INPUT_ENTITY_NAME = @"LoanInput";

NSString * const INPUT_LOAN_STARTING_BALANCE_KEY = @"startingBalance";
NSString * const LOAN_INPUT_DEFAULT_ICON_NAME = @"input-icon-loan.png";

@implementation LoanInput

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

@dynamic earlyPayoffDate;

// Inverse Relationship
@dynamic loanInterestItemizedTaxAmts;

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

-(BOOL)originationDateDefinedAndInTheFutureForScenario:(Scenario*)currentScenario
{
    if([self.origDate.simDate
        findInputValueForScenarioOrDefault:currentScenario] != nil)
    {
        NSDate *currentScenarioOrigDate = [SimInputHelper multiScenFixedDate:self.origDate.simDate
                                                                 andScenario:currentScenario];
        if([DateHelper dateIsLater:currentScenarioOrigDate otherDate:[DateHelper today]])
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    else
    {
        return FALSE;
    }
 
}

-(BOOL)originationDateDefinedAndInThePastForScenario:(Scenario*)currentScenario
{
    if([self.origDate.simDate
        findInputValueForScenarioOrDefault:currentScenario] != nil)
    {
        NSDate *currentScenarioOrigDate = [SimInputHelper multiScenFixedDate:self.origDate.simDate
                                                                 andScenario:currentScenario];
        if([DateHelper dateIsLater:[DateHelper today] otherDate:currentScenarioOrigDate])
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    else
    {
        return FALSE;
    }
    
}





@end
