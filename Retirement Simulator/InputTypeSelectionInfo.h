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
@protocol DataModelInterface;

@interface InputTypeSelectionInfo : NSObject {
    @private
// TODO - Need to replace description with another name
    NSString *description;
	@protected
	id<DataModelInterface> dataModelInterface;
	InputCreationHelper *inputCreationHelper;

}

@property(nonatomic,retain) NSString *description;
@property(nonatomic,retain) InputCreationHelper *inputCreationHelper;
@property(nonatomic,retain) id<DataModelInterface> dataModelInterface;

-(id)initWithInputCreationHelper:(InputCreationHelper*)theHelper 
	andDataModelInterface:(id<DataModelInterface>)theDataModelInterface;

- (Input*)createInput; // must be overriden

-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput;

@end

@interface ExpenseInputTypeSelectionInfo : InputTypeSelectionInfo {}@end

@interface IncomeInputTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface TransferInputTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface SavingsAccountTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface LoanInputTypeSelctionInfo : InputTypeSelectionInfo {} @end

@interface AssetInputTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface TaxInputTypeSelectionInfo : InputTypeSelectionInfo {} @end
