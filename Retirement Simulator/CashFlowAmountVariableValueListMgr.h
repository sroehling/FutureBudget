//
//  CashFlowAmountVariableValueListMgr.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VariableValueListMgr.h"

@class CashFlowInput;


@interface CashFlowAmountVariableValueListMgr : NSObject <VariableValueListMgr> {
		@private
			CashFlowInput *cashFlow;
}

- (id) initWithCashFlow:(CashFlowInput*)theCashFlow;

@property(nonatomic,retain) CashFlowInput *cashFlow;

@end
