//
//  DateSensitiveValueChangeFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldEditInfo.h"

@class VariableValueRuntimeInfo;
@class DateSensitiveValueChange;
@class ValueSubtitleTableCell;
@class VariableValue;
@class DateHelper;

@interface DateSensitiveValueChangeFieldEditInfo : NSObject <FieldEditInfo> {
    @private
		DateSensitiveValueChange *valChange;
		VariableValueRuntimeInfo *varValInfo;
		ValueSubtitleTableCell *valChangeCell;
		VariableValue *variableVal;
		UIViewController *parentController;
        DateHelper *dateHelper;
}

@property(nonatomic,retain) DateSensitiveValueChange *valChange;
@property(nonatomic,retain) VariableValueRuntimeInfo *varValInfo;
@property(nonatomic,retain) ValueSubtitleTableCell *valChangeCell;
@property(nonatomic,retain) VariableValue *variableVal;
@property(nonatomic,assign) UIViewController *parentController;
@property(nonatomic,retain) DateHelper *dateHelper;

- (id) initWithValueChange:(DateSensitiveValueChange*)valueChange 
	andVariableValueRuntimeInfo:(VariableValueRuntimeInfo*)varValueInfo
	andVariableValue:(VariableValue*)theVariableVal 
	andParentController:(UIViewController*)theController;

@end
