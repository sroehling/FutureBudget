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
@class SavingsInterestItemizedTaxAmt;
@class AccountContribItemizedTaxAmt;
@class AccountWithdrawalItemizedTaxAmt;
@class AssetGainItemizedTaxAmt;
@class LoanInterestItemizedTaxAmt;

@protocol ItemizedTaxAmtVisitor <NSObject>

-(void)visitIncomeItemizedTaxAmt:(IncomeItemizedTaxAmt*)itemizedTaxAmt;
-(void)visitExpenseItemizedTaxAmt:(ExpenseItemizedTaxAmt*)itemizedTaxAmt;
-(void)visitSavingsInterestItemizedTaxAmt:(SavingsInterestItemizedTaxAmt*)itemizedTaxAmt;

-(void)visitAccountContribItemizedTaxAmt:(AccountContribItemizedTaxAmt*)
	itemizedTaxAmt;
-(void)visitAccountWithdrawalItemizedTaxAmt:
	(AccountWithdrawalItemizedTaxAmt*)itemizedTaxAmt;
	
-(void)visitAssetGainItemizedTaxAmt:
	(AssetGainItemizedTaxAmt*)itemizedTaxAmt;
	
-(void)visitLoanInterestItemizedTaxAmt:(LoanInterestItemizedTaxAmt*)itemizedTaxAmt;

@end
