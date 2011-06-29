//
//  SharedAppValues.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NeverEndDate;

extern NSString * const SHARED_APP_VALUES_ENTITY_NAME;

@interface SharedAppValues : NSManagedObject {
@private
}
@property (nonatomic, retain) NeverEndDate * sharedNeverEndDate;

@end
