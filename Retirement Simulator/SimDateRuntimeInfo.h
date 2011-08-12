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
}

@property(nonatomic,retain) NSString *tableTitle;
@property(nonatomic,retain) NSString *tableHeader;
@property(nonatomic,retain) NSString *tableSubHeader;
@property bool supportsNeverEndDate;

- (id)initWithTableTitle:(NSString*)theTitle andHeader:(NSString*)theHeader
			andSubHeader:(NSString*)theSubHeader andSupportsNeverEndDate:(bool)doesSupportNeverEndDate;
	 
+ (SimDateRuntimeInfo*)createForInput:(Input*)theInput
	andFieldTitleKey:(NSString*)fieldTitleStringFileKey 
	andSubHeaderFormatKey:(NSString*)subHeaderFormatKey
	andSubHeaderFormatKeyNoName:(NSString*)subHeaderFormatKeyNoName;				  
				  
				  
+ (SimDateRuntimeInfo*)createForDateSensitiveValue:(VariableValueRuntimeInfo*)valRuntimeInfo
									   andVariableValue:(VariableValue*)varValue;

@end
