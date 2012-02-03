//
//  NameFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ManagedObjectFieldEditInfo.h"
#import "FieldEditInfo.h"

@class NameFieldCell;

@interface NameFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {
    @private
		NameFieldCell *cell;
}

@property(nonatomic,retain) NameFieldCell *cell;

@end
