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
		double totalEndOfYearBalance;
		
		EndOfYearInputResults *assetValues;
		double sumAssetVals;
		
		EndOfYearInputResults *loanBalances;
		double sumLoanBal;
		
		EndOfYearInputResults *acctBalances;
		double sumAcctBal;
		
		EndOfYearInputResults *incomes;
		double sumIncomes;
		
		EndOfYearInputResults *expenses;
		double sumExpense;
}

@property(nonatomic,retain) NSDate *endDate;
@property double totalEndOfYearBalance;

@property(nonatomic,retain) EndOfYearInputResults *assetValues;
@property double sumAssetVals;

@property(nonatomic,retain) EndOfYearInputResults *loanBalances;
@property double sumLoanBal;

@property(nonatomic,retain) EndOfYearInputResults *acctBalances;
@property double sumAcctBal;

@property(nonatomic,retain) EndOfYearInputResults *incomes;
@property double sumIncomes;

@property(nonatomic,retain) EndOfYearInputResults *expenses;
@property double sumExpense;


-(id)initWithEndDate:(NSDate*)endOfYearDate;

- (NSInteger)yearNumber;

- (void)logResults;

@end
