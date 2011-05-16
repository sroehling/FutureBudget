//
//  DateFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"
#import "ManagedObjectFieldEditInfo.h"


@interface DateFieldEditInfo : ManagedObjectFieldEditInfo <FieldEditInfo> {

    NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) NSDateFormatter *dateFormatter;


@end
