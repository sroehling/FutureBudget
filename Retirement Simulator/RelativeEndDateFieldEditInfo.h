//
//  RelativeEndDateFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"

@class FieldInfo;
@class ValueSubtitleTableCell;
@class SimDateRuntimeInfo;
@class DateHelper;

@interface RelativeEndDateFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> 
{
    FieldInfo *relEndDateFieldInfo;
	ValueSubtitleTableCell *relEndDateCell;
	SimDateRuntimeInfo *simDateRuntimeInfo;
    DateHelper *dateHelper;
}

@property(nonatomic,retain) FieldInfo *relEndDateFieldInfo;
@property(nonatomic,retain) ValueSubtitleTableCell *relEndDateCell;
@property(nonatomic,retain) SimDateRuntimeInfo *simDateRuntimeInfo;
@property(nonatomic,retain) DateHelper *dateHelper;


- (id)initWithRelativeEndDateFieldInfo:(FieldInfo*)theRelEndDateFieldInfo
	andSimDateRuntimeInfo:(SimDateRuntimeInfo*)theRuntimeInfo;


@end
