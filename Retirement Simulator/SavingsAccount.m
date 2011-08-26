//
//  SavingsAccount.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SavingsAccount.h"
#import "MultiScenarioInputValue.h"
#import "InputVisitor.h"
#import "LocalizationHelper.h"

NSString * const SAVINGS_ACCOUNT_ENTITY_NAME = @"SavingsAccount";
NSString * const SAVINGS_ACCOUNT_TAXABLE_CONTRIBUTIONS_KEY = @"taxableContributions";
NSString * const SAVINGS_ACCOUNT_TAXABLE_WITHDRAWALS_KEY = @"taxableWithdrawals";
NSString * const SAVINGS_ACCOUNT_TAXABLE_INTEREST_KEY = @"taxableInterest";
NSString * const SAVINGS_ACCOUNT_INTEREST_RATE_KEY = @"multiScenarioInterestRate";

@implementation SavingsAccount
@dynamic taxableContributions;
@dynamic taxableWithdrawals;
@dynamic taxableInterest;
@dynamic multiScenarioInterestRate;
@dynamic multiScenarioFixedInterestRate;


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
    [inputVisitor visitSavingsAccount:self];
}

- (NSString*)inlineInputType
{
	return LOCALIZED_STR(@"INPUT_TYPE_SAVINGS_ACCOUNT_INLINE");
}

-(NSString*)inputTypeTitle
{
	return LOCALIZED_STR(@"INPUT_TYPE_SAVINGS_ACCOUNT_TITLE");
}



@end
