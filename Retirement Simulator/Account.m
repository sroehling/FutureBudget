//
//  Account.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Account.h"
#import "InputVisitor.h"

#import "AccountInterestItemizedTaxAmt.h"
#import "AccountWithdrawalItemizedTaxAmt.h"
#import "AccountContribItemizedTaxAmt.h"


NSString * const ACCOUNT_STARTING_BALANCE_KEY = @"startingBalance";
NSString * const ACCOUNT_COST_BASIS_KEY = @"costBasis";
NSString * const ACCOUNT_ENTITY_NAME = @"Account";
NSString * const ACCOUNT_INPUT_DEFAULT_ICON_NAME = @"input-icon-piggybank.png";

@implementation Account

@dynamic startingBalance;
@dynamic costBasis;

@dynamic contribAmount;
@dynamic contribGrowthRate;

@dynamic contribRepeatFrequency;
@dynamic contribStartDate;
@dynamic contribEndDate;
@dynamic contribEnabled;

@dynamic deferredWithdrawalsEnabled;
@dynamic deferredWithdrawalDate;
@dynamic interestRate;
@dynamic dividendRate;


@dynamic withdrawalPriority;
@dynamic limitWithdrawalExpenses;

// Inverse Relationships
@dynamic accountWithdrawalItemizedTaxAmt;
@dynamic accountInterestItemizedTaxAmt;
@dynamic accountContribItemizedTaxAmt;
@dynamic acctTransferEndpointAcct;
@dynamic accountDividendItemizedTaxAmt;
@dynamic accountCapitalGainItemizedTaxAmt;
@dynamic accountCapitalLossItemizedTaxAmt;


-(void)acceptInputVisitor:(id<InputVisitor>)inputVisitor
{
    [super acceptInputVisitor:inputVisitor];
	[inputVisitor visitAccount:self];
}





@end
