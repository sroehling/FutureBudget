//
//  LoanDownPmtSimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoanOrigSimEvent.h"

#import "ExpenseDigestEntry.h"
#import "InputValDigestSummation.h"
#import "FiscalYearDigest.h"
#import "FiscalYearDigestEntries.h"
#import "LoanSimInfo.h"
#import "IncomeDigestEntry.h"



@implementation LoanOrigSimEvent

@synthesize loanInfo;


-(id)initWithEventCreator:(id<SimEventCreator>)eventCreator 
	andEventDate:(NSDate *)theEventDate andLoanInfo:(LoanSimInfo*)theLoanInfo
{
	self = [super initWithEventCreator:eventCreator andEventDate:theEventDate];
	if(self)
	{
		assert(theLoanInfo !=nil);
		self.loanInfo = theLoanInfo;
	}
	return self;
}

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	
	double downPmtAmount = [self.loanInfo downPaymentAmount];
				
	if(downPmtAmount > 0)
	{
		ExpenseDigestEntry *downPmtExpense =
			[[[ExpenseDigestEntry alloc] initWithAmount:downPmtAmount 
				andCashFlowSummation:self.loanInfo.downPaymentSum] autorelease];
		[digest.digestEntries addDigestEntry:downPmtExpense onDate:self.eventDate];
	}
	
	double totalAmtBorrowed = [self.loanInfo loanOrigAmount];
	
	
	IncomeDigestEntry *receiveMoneyForLoan  = 
		[[[IncomeDigestEntry alloc] initWithAmount:totalAmtBorrowed
		andCashFlowSummation:self.loanInfo.originationSum] autorelease];
	[digest.digestEntries addDigestEntry:receiveMoneyForLoan onDate:self.eventDate];
	
		  
}

-(void)dealloc
{
	[loanInfo release];
	[super dealloc];
}


@end
