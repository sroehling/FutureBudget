//
//  VariableValueSectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddObjectSectionInfo.h"

@interface VariableValueSectionInfo : AddObjectSectionInfo {
        @private
            NSString *varValueEntityName;
}

@property(nonatomic,retain) NSString *varValueEntityName;

@end
