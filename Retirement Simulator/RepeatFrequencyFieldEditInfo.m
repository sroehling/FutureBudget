//
//  RepeatFrequencyFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RepeatFrequencyFieldEditInfo.h"
#import "RepeatFrequencyEditViewController.h"
#import "EventRepeatFrequency.h"


@implementation RepeatFrequencyFieldEditInfo

- (NSString*)detailTextLabel
{
    
    EventRepeatFrequency *repeatFrequency = [self.fieldInfo getFieldValue];
    return [repeatFrequency description];
}

- (UIViewController*)fieldEditController
{
    
    
    RepeatFrequencyEditViewController *repeatController = 
    [[RepeatFrequencyEditViewController alloc] initWithNibName:@"RepeatFrequencyEditViewController" andFieldInfo:fieldInfo];
    [repeatController autorelease];
    return repeatController;

}


@end
