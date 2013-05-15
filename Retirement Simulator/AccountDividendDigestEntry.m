//
//  AccountDividendDigestEntry.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/6/13.
//
//

#import "AccountDividendDigestEntry.h"

#import "SimInputHelper.h"
#import "AccountSimInfo.h"
#import "Account.h"
#import "SimParams.h"
#import "MultiScenarioGrowthRate.h"
#import "InterestBearingWorkingBalance.h"
#import "DigestEntryProcessingParams.h"
#import "DateHelper.h"
#import "InputValDigestSummation.h"
#import "MultiScenarioPercent.h"
#import "WorkingBalanceMgr.h"


@implementation AccountDividendDigestEntry

@synthesize acctSimInfo;

-(void)dealloc
{
	[acctSimInfo release];
	[super dealloc];
}

-(id)initWithAcctSimInfo:(AccountSimInfo*)theSimInfo
{
	self = [super init];
	if(self)
	{
		self.acctSimInfo = theSimInfo;
	}
	return self;
}

-(id)init
{
	assert(0); // must call initWithDividend
}

-(void)processDigestEntry:(DigestEntryProcessingParams*)processingParams
{
	double annualDividendRateAsOfEventDate =
		[SimInputHelper multiScenValueAsOfDate:self.acctSimInfo.account.dividendRate.growthRate andDate:processingParams.currentDate andScenario:acctSimInfo.simParams.simScenario] / 100.0;

	double quarterlyDividendRate = annualDividendRateAsOfEventDate / 4.0;
	
	[self.acctSimInfo.acctBal advanceCurrentBalanceToDate:processingParams.currentDate];
	double currentAcctBal = [self.acctSimInfo.acctBal currentBalanceForDate:processingParams.currentDate];

	double dividendAmount = quarterlyDividendRate * currentAcctBal;

	
	NSLog(@"Dividend for acct=%@, rate/yield = %0.2f, current balance = %f, dividend amount = %0.2f, date = %@",
		self.acctSimInfo.account.name,annualDividendRateAsOfEventDate,
		currentAcctBal,dividendAmount, [[DateHelper theHelper].longDateFormatter stringFromDate:processingParams.currentDate]);


	if(dividendAmount>0.0)
	{
	
		double dividendReinvestPercAsOfEventDate =
			[SimInputHelper multiScenValueAsOfDate:self.acctSimInfo.account.dividendReinvestPercent.percent
				andDate:processingParams.currentDate andScenario:acctSimInfo.simParams.simScenario] / 100.0;
		if(dividendReinvestPercAsOfEventDate > 1.0) { dividendReinvestPercAsOfEventDate = 1.0; }
		
		double dividendPayoutPercAsOfEventDate = 1.0 - dividendReinvestPercAsOfEventDate;
	
		if(dividendReinvestPercAsOfEventDate > 0.0)
		{
			// Re-invest the dividend back into the account.
			[self.acctSimInfo addContribution:(dividendAmount * dividendReinvestPercAsOfEventDate)
				onDate:processingParams.currentDate];
		}
		if(dividendPayoutPercAsOfEventDate > 0.0)
		{
			// If the reinvestment % is less than 100%, then payout the remainder
			// to the cash balance
			[processingParams.workingBalanceMgr
				incrementCashBalance:(dividendAmount * dividendPayoutPercAsOfEventDate)
				asOfDate:processingParams.currentDate];
		}

		// Keep a tally of dividend payment for tax purposes.
		[self.acctSimInfo.dividendPayments adjustSum:dividendAmount onDay:processingParams.dayIndex];
		
	}

}



@end
