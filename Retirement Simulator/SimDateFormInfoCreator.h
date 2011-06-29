//
//  VariableDateFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"
#import "ManagedObjectFieldInfo.h"
#import "FixedDate.h"

@class SimDateRuntimeInfo;

@interface SimDateFormInfoCreator : NSObject <FormInfoCreator> {
    @private
        ManagedObjectFieldInfo *fieldInfo;
        FixedDate *fixedDate;
		SimDateRuntimeInfo *varDateRuntimeInfo;
		bool showNeverEndingDate;
}

- (id)initWithVariableDateFieldInfo:(ManagedObjectFieldInfo*)vdFieldInfo 
             andDefaultValFieldInfo:(ManagedObjectFieldInfo*)theDefaultFieldInfo
			 andVarDateRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo
			 andDoShowNeverEnding:(bool)doShowNeverEnding;

@property(nonatomic,retain) ManagedObjectFieldInfo *fieldInfo;
@property(nonatomic,retain) FixedDate *fixedDate;
@property(nonatomic,retain) SimDateRuntimeInfo *varDateRuntimeInfo;
@property bool showNeverEnding;

@end
