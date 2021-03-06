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
@synthesize cashFlow;
@synthesize deficitBal;
@synthesize acctContribs;
@synthesize sumAcctContrib;
@synthesize acctWithdrawals;
@synthesize sumAcctWithdrawal;
@synthesize acctDividends;
@synthesize sumAcctDividend;
@synthesize acctCapitalGains;
@synthesize sumAcctCapitalGains;
@synthesize acctCapitalLoss;
@synthesize sumAcctCapitalLoss;

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
	[acctCapitalGains release];
	[acctCapitalLoss release];
	
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

		self.acctCapitalGains = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumAcctCapitalGains = 0.0;

		self.acctCapitalLoss = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumAcctCapitalLoss = 0.0;

		self.incomes = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumIncomes = 0.0;
		
		self.expenses = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumExpense = 0.0;
		
		self.taxesPaid = [[[EndOfYearInputResults alloc] init] autorelease];
		self.sumTaxesPaid = 0.0;
		
		self.cashBal = 0.0;
		self.cashFlow = 0.0;
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
    // The calendar classes are not thread safe. Since the simulator itself uses DateUtil
    // and this method is called from the results views & plots (being executed in separate
    // threads), a dedicated NSCalendar is needed to return the year number.
    NSCalendar *cal = [[[NSCalendar alloc]
                        initWithCalendarIdentifier:NSGregorianCalendar] autorelease];    
    NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *components = [cal components:componentFlags fromDate:self.endDate];

    return [components year];    
}

- (void)logResults
{

}


@end
