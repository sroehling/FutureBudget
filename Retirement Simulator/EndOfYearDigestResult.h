//
//  EndOfYearDigestResult.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EndOfYearInputResults;

@interface EndOfYearDigestResult : NSObject {
    @private
		NSDate *endDate;
		BOOL fullYearSimulated;
		
		double totalEndOfYearBalance;
		
		EndOfYearInputResults *assetValues;
		double sumAssetVals;
		
		EndOfYearInputResults *loanBalances;
		double sumLoanBal;
		
		EndOfYearInputResults *acctBalances;
		double sumAcctBal;
		
		EndOfYearInputResults *acctContribs;
		double sumAcctContrib;
		
		EndOfYearInputResults *acctWithdrawals;
		double sumAcctWithdrawal;
		
		EndOfYearInputResults *incomes;
		double sumIncomes;
		
		EndOfYearInputResults *expenses;
		double sumExpense;
		
		EndOfYearInputResults *taxesPaid;
		double sumTaxesPaid;
		
		double cashBal;
		
		double deficitBal;
		
		// This multiplier will take the unadjusted results, given 
		// in "future dollars" and adjust it back to the "current dollars".
		double simStartDateValueMultiplier;
}

@property(nonatomic,retain) NSDate *endDate;
@property BOOL fullYearSimulated;
@property double totalEndOfYearBalance;

@property(nonatomic,retain) EndOfYearInputResults *assetValues;
@property double sumAssetVals;

@property(nonatomic,retain) EndOfYearInputResults *loanBalances;
@property double sumLoanBal;

@property(nonatomic,retain) EndOfYearInputResults *acctBalances;
@property double sumAcctBal;

@property(nonatomic,retain) EndOfYearInputResults *acctContribs;
@property double sumAcctContrib;

@property(nonatomic,retain) EndOfYearInputResults *acctWithdrawals;
@property double sumAcctWithdrawal;

@property(nonatomic,retain) EndOfYearInputResults *incomes;
@property double sumIncomes;

@property(nonatomic,retain) EndOfYearInputResults *expenses;
@property double sumExpense;

@property(nonatomic,retain) EndOfYearInputResults *taxesPaid;
@property double sumTaxesPaid;

@property double cashBal;

@property double deficitBal;

@property double simStartDateValueMultiplier;

-(id)initWithEndDate:(NSDate *)endOfYearDate andFullYearSimulated:(BOOL)theFullYearSimulated;

- (NSInteger)yearNumber;

- (void)logResults;

@end
