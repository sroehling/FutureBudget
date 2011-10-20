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
@class InputCreationHelper;

@interface InputTypeSelectionInfo : NSObject {
    @private
// TODO - Need to replace description with another name
    NSString *description;
	@protected
	InputCreationHelper *inputCreationHelper;

}

@property(nonatomic,retain) NSString *description;
@property(nonatomic,retain) InputCreationHelper *inputCreationHelper;

- (Input*)createInput; // must be overriden

-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput;

@end

@interface ExpenseInputTypeSelectionInfo : InputTypeSelectionInfo {}@end

@interface IncomeInputTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface SavingsAccountTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface LoanInputTypeSelctionInfo : InputTypeSelectionInfo {} @end

@interface AssetInputTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface TaxInputTypeSelectionInfo : InputTypeSelectionInfo {} @end
