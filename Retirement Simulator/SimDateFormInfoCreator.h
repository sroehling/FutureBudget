//
//  VariableDateFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class FieldInfo;
@class SimDateRuntimeInfo;

@interface SimDateFormInfoCreator : NSObject <FormInfoCreator> {
    @private
        FieldInfo *fieldInfo;
        FieldInfo *fixedDateFieldInfo;
		SimDateRuntimeInfo *varDateRuntimeInfo;
		bool showNeverEnding;
}

- (id)initWithVariableDateFieldInfo:(FieldInfo*)vdFieldInfo 
             andDefaultValFieldInfo:(FieldInfo*)theDefaultFieldInfo
			 andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
			 andDoShowNeverEnding:(bool)doShowNeverEnding;

@property(nonatomic,retain) FieldInfo *fieldInfo;
@property(nonatomic,retain) FieldInfo* fixedDateFieldInfo;
@property(nonatomic,retain) SimDateRuntimeInfo *varDateRuntimeInfo;

@end
