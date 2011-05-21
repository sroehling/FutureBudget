//
//  DateSensitiveValueFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateSensitiveValueFieldEditInfo.h"
#import "DateSensitiveValueFieldEditViewController.h"
#import "DateSensitiveValue.h"


@implementation DateSensitiveValueFieldEditInfo

@synthesize variableValueEntityName;

- (NSString*)detailTextLabel
{
    DateSensitiveValue *dsValue = [self.fieldInfo getFieldValue];
    return [dsValue valueDescription];
}

- (UIViewController*)fieldEditController
{
    DateSensitiveValueFieldEditViewController *dsValueController = 
        [[DateSensitiveValueFieldEditViewController alloc] initWithFieldInfo:fieldInfo];
    assert(self.variableValueEntityName != nil);
    assert([self.variableValueEntityName length] > 0);
    dsValueController.variableValueEntityName = self.variableValueEntityName;
    [dsValueController autorelease];
    return dsValueController;
}

@end
