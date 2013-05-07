//
//  EndOfYearDigestResult.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EndOfYearDigestResult.h"
#import "NumberHelper.h"
#import "DateHelper.h"
#import "EndOfYearInputResults.h"

@implementation EndOfYearDigestResult

@synthesize endDate;
@synthesize totalEndOfYearBalance;
@synthesize assetValues;
@synthesize sumAssetVals;
@synthesize loanBalances;
@synthesize sumLoanBal;
@synthesize acctBalances;
@synthesize sumAcctBal;
@synthesize incomes;
@synthesize sumIncomes;
@synthesize expenses;
@synthesize sumExpense;
@synthesize cashBal;
@synthesize deficitBal;
@synthesize acctContribs;
@synthesize sumAcctContrib;
@synthesize acctWithdrawals;
@synthesize sumAcctWithdrawal;
@synthesize acctDividends;
@synthesize sumAcctDividend;

@synthesize simStartDateValueMultiplier;
@synthesize taxesPaid;
@synthesize sumTaxesPaid;
@synthesize fullYearSimulated;

- (void) dealloc
{
	[assetValues release];
	[loanBalances release];
	
	[incomes release];
	[expenses release];
	
	[acctBalances release];
	[acctWithdrawals release];
	[acctContribs release];
	[acctDividends release];
	
	[taxesPaid release];
	
	[super dealloc];
}

-(id)initWithEndDate:(NSDate *)endOfYearDate andFullYearSimulated:(BOOL)theFullYearSimulated
{
	self = [super init];
	if(self)
	{
		assert(endOfYearDate != nil);
		self.endDate = endOfYearDate;
		self.totalEndOfYearBalance = 0.0;
		
		self.assetValues = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumAssetVals = 0.0;
		
		self.loanBalances = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumLoanBal = 0.0;
				
		self.acctBalances = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumAcctBal = 0.0;

		self.acctContribs = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumAcctContrib = 0.0;
		
		self.acctWithdrawals = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumAcctWithdrawal = 0.0;

		self.acctDividends = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumAcctDividend = 0.0;

		self.incomes = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumIncomes = 0.0;
		
		self.expenses = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumExpense = 0.0;
		
		self.taxesPaid = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumTaxesPaid = 0.0;
		
		self.cashBal = 0.0;
		
		self.deficitBal = 0.0;
		
		self.fullYearSimulated = theFullYearSimulated;
	}
	return self;

}

-(id) init
{
	assert(0); // must call with end date
}


- (NSInteger)yearNumber
{
	return [DateHelper yearOfDate:self.endDate];
}

- (void)logResults
{

}


@end
