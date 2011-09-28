//
//  InputTypeSelectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Input;
@class CashFlowInput;

@interface InputTypeSelectionInfo : NSObject {
    @private
// TODO - Need to replace description with another name
    NSString *description;

}

@property(nonatomic,retain) NSString *description;

- (Input*)createInput; // must be overriden

-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput;

@end

@interface ExpenseInputTypeSelectionInfo : InputTypeSelectionInfo {}@end

@interface IncomeInputTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface SavingsAccountTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface LoanInputTypeSelctionInfo : InputTypeSelectionInfo {} @end

@interface AssetInputTypeSelectionInfo : InputTypeSelectionInfo {} @end
