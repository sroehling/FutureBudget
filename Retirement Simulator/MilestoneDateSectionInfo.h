//
//  MilestoneDateSectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddObjectSectionInfo.h"

@class SimDateRuntimeInfo;

@interface MilestoneDateSectionInfo : AddObjectSectionInfo {
	@private
		SimDateRuntimeInfo *varDateRuntimeInfo;
}

@property(nonatomic,retain) SimDateRuntimeInfo *varDateRuntimeInfo;

-(id)initWithRuntimeInfo:(SimDateRuntimeInfo*)theVarDateRuntimeInfo;

@end
