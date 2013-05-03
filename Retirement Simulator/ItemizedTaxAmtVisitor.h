//
//  ItemizedTaxAmtVisitor.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IncomeItemizedTaxAmt;
@class ExpenseItemizedTaxAmt;
@class AccountInterestItemizedTaxAmt;
@class AccountContribItemizedTaxAmt;
@class AccountWithdrawalItemizedTaxAmt;
@class AssetGainItemizedTaxAmt;
@class LoanInterestItemizedTaxAmt;
@class TaxesPaidItemizedTaxAmt;
@class AccountDividendItemizedTaxAmt;

@protocol ItemizedTaxAmtVisitor <NSObject>

-(void)visitIncomeItemizedTaxAmt:(IncomeItemizedTaxAmt*)itemizedTaxAmt;
-(void)visitExpenseItemizedTaxAmt:(ExpenseItemizedTaxAmt*)itemizedTaxAmt;

-(void)visitAccountInterestItemizedTaxAmt:(AccountInterestItemizedTaxAmt*)itemizedTaxAmt;
-(void)visitAccountDividendItemizedTaxAmt:(AccountDividendItemizedTaxAmt*)itemizedTaxAmt;
-(void)visitAccountContribItemizedTaxAmt:(AccountContribItemizedTaxAmt*)
	itemizedTaxAmt;
-(void)visitAccountWithdrawalItemizedTaxAmt:
	(AccountWithdrawalItemizedTaxAmt*)itemizedTaxAmt;
	
-(void)visitAssetGainItemizedTaxAmt:
	(AssetGainItemizedTaxAmt*)itemizedTaxAmt;
	
-(void)visitTaxesPaidItemizedTaxAmt:
	(TaxesPaidItemizedTaxAmt*)ItemizedTaxAmt;
	
-(void)visitLoanInterestItemizedTaxAmt:(LoanInterestItemizedTaxAmt*)itemizedTaxAmt;

@end
