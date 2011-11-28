//
//  ItemizedTaxAmtFieldPopulator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemizedTaxAmtVisitor.h"

@class ItemizedTaxAmts;

@interface ItemizedTaxAmtFieldPopulator : NSObject <ItemizedTaxAmtVisitor> {
	@private
		ItemizedTaxAmts *itemizedTaxAmts;
		
		NSMutableArray *itemizedIncomes;
		NSMutableArray *itemizedExpenses;
		NSMutableArray *itemizedAccountInterest;
		NSMutableArray *itemizedAccountContribs;
		NSMutableArray *itemizedAccountWithdrawals;
		NSMutableArray *itemizedAssets;
		NSMutableArray *itemizedLoans;
}


@property(nonatomic,retain) ItemizedTaxAmts *itemizedTaxAmts;

@property(nonatomic,retain) NSMutableArray *itemizedIncomes;
@property(nonatomic,retain) NSMutableArray *itemizedExpenses;
@property(nonatomic,retain) NSMutableArray *itemizedAccountInterest;
@property(nonatomic,retain) NSMutableArray *itemizedAccountContribs;
@property(nonatomic,retain) NSMutableArray *itemizedAccountWithdrawals;
@property(nonatomic,retain) NSMutableArray *itemizedAssets;
@property(nonatomic,retain) NSMutableArray *itemizedLoans;

-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts;

- (NSArray*)incomesNotAlreadyItemized;
- (NSArray*)expensesNotAlreadyItemized;
- (NSArray*)acctWithdrawalsNotAlreadyItemized;
- (NSArray*)acctContribsNotAlreadyItemized;
- (NSArray*)acctInterestNotAlreadyItemized;
- (NSArray*)assetGainsNotAlreadyItemized;
- (NSArray*)loanInterestNotAlreadyItemized;

@end
