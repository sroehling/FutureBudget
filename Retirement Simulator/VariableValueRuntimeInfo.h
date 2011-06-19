//
//  VariableValueRuntimeInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VariableValueListMgr.h"

@class CashFlowInput;

@interface VariableValueRuntimeInfo : NSObject {
	@private
		NSNumberFormatter *valueFormatter;
		NSString *valueTitle;
		NSString *inlineValueTitleKey;
		NSString *valueVerb;
		NSString *periodDesc;
		id<VariableValueListMgr> listMgr;
		NSString *singleValSubtitleKey;
		NSString *variableValSubtitleKey;
		NSString *valuePromptKey;
		NSString *valueTypeTitle;
		NSString *valueTypeInline;
		NSString *valueName;
		NSString *tableSubtitle;
}

@property(nonatomic,retain) NSNumberFormatter *valueFormatter;
@property(nonatomic,retain) NSString *valueTitle;
@property(nonatomic,retain) NSString *valueVerb;
@property(nonatomic,retain) NSString *periodDesc;
@property(nonatomic,retain) id<VariableValueListMgr> listMgr;
@property(nonatomic,retain) NSString *singleValSubtitleKey;
@property(nonatomic,retain) NSString *variableValSubtitleKey;
@property(nonatomic,retain) NSString *inlineValueTitleKey;
@property(nonatomic,retain) NSString *valuePromptKey;
@property(nonatomic,retain) NSString *valueTypeTitle;
@property(nonatomic,retain) NSString *valueTypeInline;
@property(nonatomic,retain) NSString *valueName;
@property(nonatomic,retain) NSString *tableSubtitle;


- (id) initWithFormatter:(NSNumberFormatter*)valFormatter
		   andValueTitle:(NSString*)title 
  andInlineValueTitleKey:(NSString*)theInlineValueTitleKey
			andValueVerb:(NSString*)verb
		   andPeriodDesc:(NSString*)thePeriodDesc 
			  andListMgr:(id<VariableValueListMgr>)theListMgr
andSingleValueSubtitleKey:(NSString*)theSingleValSubtitleKey 
andVariableValueSubtitleKey:(NSString*)theVarValSubtitleKey
	   andValuePromptKey:(NSString*)theValPromptKey
	  andValueTypeInline:(NSString*)theValueTypeInline
	   andValueTypeTitle:(NSString*)theValueTypeTitle
			andValueName:(NSString*)theValueName
			andTableSubtitle:(NSString*)theTableSubtitle;
	
- (NSString *)inlinePeriodDesc;


+ (VariableValueRuntimeInfo*)createForCashflowAmount:(CashFlowInput*)cashFlow;
+ (VariableValueRuntimeInfo*)createForInflationRate:(CashFlowInput*)cashFlow;

@end
