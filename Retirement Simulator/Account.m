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

NSString * const ACCOUNT_MULTI_SCEN_CONTRIB_REPEAT_FREQUENCY_KEY = @"multiScenarioContribRepeatFrequency";

@implementation Account

@dynamic startingBalance;
@dynamic contribAmount;
@dynamic contribGrowthRate;

@dynamic multiScenarioContribRepeatFrequency;
@dynamic contribStartDate;
@dynamic contribEndDate;
@dynamic multiScenarioContribEnabled;

@dynamic multiScenarioDeferredWithdrawalsEnabled;
@dynamic deferredWithdrawalDate;


@dynamic multiScenarioWithdrawalPriority;


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
	[inputVisitor visitAccount:self];
}



@end
