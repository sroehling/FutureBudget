//
//  VariableValueSectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddObjectSectionInfo.h"
#import "VariableValueRuntimeInfo.h"

@interface VariableValueSectionInfo : AddObjectSectionInfo {
        @private
            VariableValueRuntimeInfo *varValRuntimeInfo;
}

- (id) initWithVariableValueRuntimeInfo:(VariableValueRuntimeInfo*)varValRuntimeInfo;

@property(nonatomic,retain) VariableValueRuntimeInfo *varValRuntimeInfo;

@end
