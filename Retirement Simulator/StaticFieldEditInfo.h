//
//  StaticFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
@class ValueSubtitleTableCell;

@interface StaticFieldEditInfo : NSObject <FieldEditInfo> {
@private
	NSManagedObject *fieldObj;
	ValueSubtitleTableCell *staticCell;
	NSString *caption;
	NSString *content;
}

@property(nonatomic,retain) NSManagedObject *fieldObj;
@property(nonatomic,retain) ValueSubtitleTableCell *staticCell;
@property(nonatomic,retain) NSString *caption;
@property(nonatomic,retain) NSString *content;

- (id) initWithManagedObj:(NSManagedObject*)theFieldObj andCaption:(NSString*)theCaption 
andContent:(NSString*)theContent;

@end
