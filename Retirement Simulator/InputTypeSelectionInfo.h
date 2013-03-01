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
@class DataModelController;

@interface InputTypeSelectionInfo : NSObject {
    @private
		NSString *inputLabel;
		NSString *subTitle;
		NSString *imageName;
	@protected
	
	DataModelController *dataModelController;
	InputCreationHelper *inputCreationHelper;

}

@property(nonatomic,retain) NSString *inputLabel;
@property(nonatomic,retain) NSString *subTitle;
@property(nonatomic,retain) NSString *imageName;
@property(nonatomic,retain) InputCreationHelper *inputCreationHelper;
@property(nonatomic,retain) DataModelController *dataModelController;

-(id)initWithInputCreationHelper:(InputCreationHelper*)theHelper 
	andDataModelController:(DataModelController *)theDataModelController
	andLabel:(NSString*)theLabel andSubtitle:(NSString*)theSubTitle
	andImageName:(NSString*)theImageName;

- (Input*)createInput; // must be overriden

-(void)populateCashFlowInputProperties:(CashFlowInput*)newInput;

@end

@interface ExpenseInputTypeSelectionInfo : InputTypeSelectionInfo {}@end

@interface IncomeInputTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface TransferInputTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface SavingsAccountTypeSelectionInfo : InputTypeSelectionInfo {} @end

@interface LoanInputTypeSelctionInfo : InputTypeSelectionInfo {} @end

@interface AssetInputTypeSelectionInfo : InputTypeSelectionInfo {} @end

// NOTE: TaxInputTypeSelectionInfo is defined in its own file, since it
// has a more involved implementation.
