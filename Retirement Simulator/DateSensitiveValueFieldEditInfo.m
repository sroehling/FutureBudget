//
//  DateSensitiveValueFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueFieldEditInfo.h"
#import "DateSensitiveValue.h"


@implementation DateSensitiveValueFieldEditInfo

- (NSString*)detailTextLabel
{
    
    DateSensitiveValue *dsValue = [self.fieldInfo getFieldValue];
    return [dsValue valueDescription];
}

- (UIViewController*)fieldEditController
{
    
#warning need new field edit controller for DateSensitiveValue
    
    /*
    RepeatFrequencyEditViewController *repeatController = 
    [[RepeatFrequencyEditViewController alloc] initWithFieldInfo:fieldInfo];
    [repeatController autorelease];
    return repeatController;
    */
    assert(0);
    return nil;
     
}



@end
