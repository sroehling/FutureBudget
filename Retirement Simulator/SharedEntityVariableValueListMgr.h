//
//  SharedEntityVariableValueListMgr.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VariableValueListMgr.h"
#import "FinishedAddingObjectListener.h"

@interface SharedEntityVariableValueListMgr : NSObject <VariableValueListMgr,FinishedAddingObjectListener> {
    @private
		NSString *entityName;
}

- (id) initWithEntity:(NSString *)entityName;

@property(nonatomic,retain) NSString *entityName;

@end
