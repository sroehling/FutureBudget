//
//  VariableDateRuntimeInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CashFlowInput;
@class VariableValueRuntimeInfo;
@class VariableValue;

@interface VariableDateRuntimeInfo : NSObject {
	@private
		NSString *tableTitle;
		NSString *tableHeader;
		NSString *tableSubHeader;
}

@property(nonatomic,retain) NSString *tableTitle;
@property(nonatomic,retain) NSString *tableHeader;
@property(nonatomic,retain) NSString *tableSubHeader;

- (id)initWithTableTitle:(NSString*)theTitle andHeader:(NSString*)theHeader
     andSubHeader:(NSString*)theSubHeader;
	 
+ (VariableDateRuntimeInfo*)createForCashFlow:(CashFlowInput*)cashFlow
							 andFieldTitleKey:(NSString*)fieldTitleStringFileKey 
						andSubHeaderFormatKey:(NSString*)subHeaderFormatKey
				  andSubHeaderFormatKeyNoName:(NSString*)subHeaderFormatKeyNoName;
+ (VariableDateRuntimeInfo*)createForDateSensitiveValue:(VariableValueRuntimeInfo*)valRuntimeInfo
									   andVariableValue:(VariableValue*)varValue;

@end
