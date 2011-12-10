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

-(id)initWithEndDate:(NSDate *)endOfYearDate
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
		
		self.incomes = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumIncomes = 0.0;
		
		self.expenses = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumExpense = 0.0;
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

- (void) dealloc
{
	[super dealloc];
	[assetValues release];
	[loanBalances release];
	[acctBalances release];
	[incomes release];
	[expenses release];
}

@end
