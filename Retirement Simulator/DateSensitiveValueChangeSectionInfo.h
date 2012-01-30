//
//  DateSensitiveValueChangeSectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddObjectSectionInfo.h"
@class VariableValueRuntimeInfo;
@class VariableValue;

@interface DateSensitiveValueChangeSectionInfo : AddObjectSectionInfo {
    @private
		VariableValueRuntimeInfo *variableValRuntimeInfo;
		VariableValue *variableVal;
}

@property(nonatomic,retain) VariableValueRuntimeInfo *variableValRuntimeInfo;
@property(nonatomic,retain) VariableValue *variableVal;

- (id) initWithVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo
	andParentVariableValue:(VariableValue*)varValue 
	andParentController:(UIViewController *)theParentController;

@end
