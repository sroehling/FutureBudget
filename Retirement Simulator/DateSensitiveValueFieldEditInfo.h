//
//  DateSensitiveValueFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagedObjectFieldEditInfo.h"

@interface DateSensitiveValueFieldEditInfo : ManagedObjectFieldEditInfo {
    @private 
    NSString *variableValueEntityName;
}

@property(nonatomic,retain) NSString *variableValueEntityName;

@end
