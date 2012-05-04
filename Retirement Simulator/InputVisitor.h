//
//  InputVisitor.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CashFlowInput;
@class ExpenseInput;
@class IncomeInput;
@class SavingsAccount;
@class Account;
@class LoanInput;
@class AssetInput;
@class TaxInput;
@class TransferInput;

@protocol InputVisitor <NSObject>

- (void)visitCashFlow:(CashFlowInput*)cashFlow;
- (void)visitExpense:(ExpenseInput*)expense;
- (void)visitIncome:(IncomeInput*)income;
- (void)visitAccount:(Account*)account;
- (void)visitSavingsAccount:(SavingsAccount*)savingsAcct;
- (void)visitLoan:(LoanInput*)loan;
- (void)visitAsset:(AssetInput*)asset;
- (void)visitTax:(TaxInput*)tax;
- (void)visitTransfer:(TransferInput*)transfer;

@end
