//
//  VariableDateRuntimeInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Input;
@class VariableValueRuntimeInfo;
@class VariableValue;

@interface SimDateRuntimeInfo : NSObject {
	@private
		NSString *tableTitle;
		NSString *tableHeader;
		NSString *tableSubHeader;
		bool supportsNeverEndDate;
		NSString *neverEndDateSectionTitle;
		NSString *neverEndDateHelpFile;
		NSString *neverEndDateFieldCaption;
		NSString *neverEndDateFieldSubtitle;
		NSString *relEndDateSectionTitle;
		NSString *relEndDateHelpFile;
		NSString *relEndDateFieldLabel;
}

@property(nonatomic,retain) NSString *tableTitle;
@property(nonatomic,retain) NSString *tableHeader;
@property(nonatomic,retain) NSString *tableSubHeader;
@property bool supportsNeverEndDate;
@property(nonatomic,retain) NSString *neverEndDateSectionTitle;
@property(nonatomic,retain) NSString *neverEndDateHelpFile;
@property(nonatomic,retain) NSString *neverEndDateFieldCaption;
@property(nonatomic,retain) NSString *neverEndDateFieldSubtitle;
@property(nonatomic,retain) NSString *relEndDateSectionTitle;
@property(nonatomic,retain) NSString *relEndDateHelpFile;
@property(nonatomic,retain) NSString *relEndDateFieldLabel;

- (id)initWithTableTitle:(NSString*)theTitle andHeader:(NSString*)theHeader
			andSubHeader:(NSString*)theSubHeader andSupportsNeverEndDate:(bool)doesSupportNeverEndDate;
	 
+ (SimDateRuntimeInfo*)createForInput:(Input*)theInput
	andFieldTitleKey:(NSString*)fieldTitleStringFileKey 
	andSubHeaderFormatKey:(NSString*)subHeaderFormatKey
	andSubHeaderFormatKeyNoName:(NSString*)subHeaderFormatKeyNoName;				  
				  
				  
+ (SimDateRuntimeInfo*)createForDateSensitiveValue:(VariableValueRuntimeInfo*)valRuntimeInfo
									   andVariableValue:(VariableValue*)varValue;

@end
