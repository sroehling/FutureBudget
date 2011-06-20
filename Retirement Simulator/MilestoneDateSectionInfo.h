//
//  MilestoneDateSectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddObjectSectionInfo.h"

@class VariableDateRuntimeInfo;

@interface MilestoneDateSectionInfo : AddObjectSectionInfo {
	@private
		VariableDateRuntimeInfo *varDateRuntimeInfo;
}

@property(nonatomic,retain) VariableDateRuntimeInfo *varDateRuntimeInfo;

-(id)initWithRuntimeInfo:(VariableDateRuntimeInfo*)theVarDateRuntimeInfo;

@end
