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

@protocol ItemizedTaxAmtVisitor <NSObject>

-(void)visitIncomeItemizedTaxAmt:(IncomeItemizedTaxAmt*)itemizedTaxAmt;
-(void)visitExpenseItemizedTaxAmt:(ExpenseItemizedTaxAmt*)itemizedTaxAmt;
-(void)visitSavingsInterestItemizedTaxAmt:(SavingsInterestItemizedTaxAmt*)itemizedTaxAmt;

@end
