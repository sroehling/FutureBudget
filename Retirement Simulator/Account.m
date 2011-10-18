//
//  Account.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Account.h"
#import "InputVisitor.h"



NSString * const ACCOUNT_STARTING_BALANCE_KEY = @"startingBalance";
NSString * const ACCOUNT_ENTITY_NAME = @"Account";
NSString * const ACCOUNT_CONTRIB_AMOUNT_ENTITY_NAME = @"AccountContribAmount";

NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_REPEAT_FREQUENCY_KEY = @"multiScenarioContribRepeatFrequency";
NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_START_DATE_KEY = @"multiScenarioContribStartDate";
NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_END_DATE_KEY = @"multiScenarioContribEndDate";

NSString * const ACCOUNT_MULTI_SCEN_DEFERRED_WITHDRAWAL_DATE_KEY = @"multiScenarioDeferredWithdrawalDate";

@implementation Account

@dynamic startingBalance;
@dynamic contribAmount;
@dynamic contribGrowthRate;

@dynamic multiScenarioContribRepeatFrequency;
@dynamic multiScenarioContribStartDate;
@dynamic multiScenarioContribEndDate;

@dynamic multiScenarioFixedContribStartDate;
@dynamic multiScenarioFixedContribEndDate;
@dynamic multiScenarioFixedContribRelEndDate;
@dynamic multiScenarioContribEnabled;

@dynamic multiScenarioDeferredWithdrawalsEnabled;
@dynamic multiScenarioDeferredWithdrawalDate;
@dynamic multiScenarioDeferredWithdrawalDateFixed;


@dynamic multiScenarioWithdrawalPriority;


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
	[inputVisitor visitAccount:self];
}



@end
