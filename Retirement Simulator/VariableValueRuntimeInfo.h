//
//  VariableValueRuntimeInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VariableValueListMgr.h"

@class Input;
@class CashFlowInput;
@class LoanInput;
@class Account;
@class MultiScenarioAmount;
@class NumberFieldValidator;
@class DataModelController;

@interface VariableValueRuntimeInfo : NSObject {
	@private
		NSNumberFormatter *valueFormatter;
		NumberFieldValidator *valueValidator;
		NSString *valueTitleKey;
		NSString *inlineValueTitleKey;
		NSString *valueVerb;
		NSString *periodDesc;
		id<VariableValueListMgr> listMgr;
		NSString *singleValHelpInfoFile;
		NSString *variableValHelpInfoFile;
		NSString *valuePromptKey;
		NSString *valueTypeTitle;
		NSString *valueName;
		NSString *tableSubtitle;
}

@property(nonatomic,retain) NSNumberFormatter *valueFormatter;
@property(nonatomic,retain) NumberFieldValidator *valueValidator;
@property(nonatomic,retain) NSString *valueTitleKey;
@property(nonatomic,retain) NSString *valueVerb;
@property(nonatomic,retain) NSString *periodDesc;
@property(nonatomic,retain) id<VariableValueListMgr> listMgr;
@property(nonatomic,retain) NSString *singleValHelpInfoFile;
@property(nonatomic,retain) NSString *variableValHelpInfoFile;
@property(nonatomic,retain) NSString *inlineValueTitleKey;
@property(nonatomic,retain) NSString *valuePromptKey;
@property(nonatomic,retain) NSString *valueTypeTitle;
@property(nonatomic,retain) NSString *valueName;
@property(nonatomic,retain) NSString *tableSubtitle;


- (id) initWithFormatter:(NSNumberFormatter*)valFormatter
			andValueValidator:(NumberFieldValidator*)valValidator
		   andValueTitle:(NSString*)title 
		andInlineValueTitleKey:(NSString*)theInlineValueTitleKey
			andValueVerb:(NSString*)verb
		   andPeriodDesc:(NSString*)thePeriodDesc 
			  andListMgr:(id<VariableValueListMgr>)theListMgr
		andSingleValHelpInfoFile:(NSString*)theSingleValHelpInfoFile 
		andVariableValHelpInfoFile:(NSString*)theHelpInfoFile
	   andValuePromptKey:(NSString*)theValPromptKey
	   andValueTypeTitle:(NSString*)theValueTypeTitle
	   andValueName:(NSString*)theValueName
	   andTableSubtitle:(NSString*)theTableSubtitle;
	
- (NSString *)inlinePeriodDesc;


+ (VariableValueRuntimeInfo*)createForSharedInflationRateWithDataModelController:(DataModelController*)dataModelController andInput:(Input*)theInput;
+ (VariableValueRuntimeInfo*)createForSharedInterestRateWithDataModelController:
	(DataModelController*)dataModelController andInput:(Input*)theInput;
+ (VariableValueRuntimeInfo*)createForVariableAmount:(Input*)theInput 
	andVariableValListMgr:(id<VariableValueListMgr>)listMgr;
	
+(VariableValueRuntimeInfo*)createForDataModelController:(DataModelController*)dataModelController 
	andMultiScenarioAmount:(MultiScenarioAmount*)theAmount 
	withValueTitle:(NSString*)valueTitle andValueName:(NSString*)valueName;	

@end
