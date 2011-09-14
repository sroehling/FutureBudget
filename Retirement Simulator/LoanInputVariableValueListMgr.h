//
//  LoanInputVariableValueListMgr.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VariableValueListMgr.h"
#import "LoanInput.h"


@interface LoanInputVariableValueListMgr : NSObject<VariableValueListMgr>  {
    @protected
		LoanInput *loan;
		NSString *variableValEntityName;
}

@property(nonatomic,retain) LoanInput *loan;
@property(nonatomic,retain) NSString *variableValEntityName;
-(id)initWithLoan:(LoanInput*)theLoan;

@end


@interface LoanCostAmtVariableValueListMgr: LoanInputVariableValueListMgr { } @end
@interface LoanExtraPmtAmountVariableValueListMgr: LoanInputVariableValueListMgr { } @end
@interface LoanDownPmtAmountVariableValueListMgr: LoanInputVariableValueListMgr { } @end