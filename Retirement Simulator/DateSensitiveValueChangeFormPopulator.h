//
//  DateSensitiveValueChangeFormPopulator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormPopulator.h"

@class DateSensitiveValueChange;
@class VariableValueRuntimeInfo;
@class VariableValue;

@interface DateSensitiveValueChangeFormPopulator : FormPopulator {
    
}

- (UIViewController*)addViewControllerForValueChange:(DateSensitiveValueChange*)valueChange
						   andVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo
						   andParentVariableValue:(VariableValue*)varValue;
						   
- (UIViewController*)editViewControllerForValueChange:(DateSensitiveValueChange*)valueChange
							andVariableValRuntimeInfo:(VariableValueRuntimeInfo*)valRuntimeInfo;

@end
