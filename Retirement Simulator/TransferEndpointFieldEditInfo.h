//
//  TransferEndpointFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"

@class ValueSubtitleTableCell;
@class ManagedObjectFieldInfo;
@class ManagedObjectFieldInfo;

@interface TransferEndpointFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo>  {
    @private
		ValueSubtitleTableCell *valueCell;
		ManagedObjectFieldInfo *endpointFieldInfo;

}

@property(nonatomic,retain) ValueSubtitleTableCell *valueCell;
@property(nonatomic,retain) ManagedObjectFieldInfo *endpointFieldInfo;

- (id)initWithManagedObjFieldInfo:(ManagedObjectFieldInfo *)theFieldInfo;

@end
