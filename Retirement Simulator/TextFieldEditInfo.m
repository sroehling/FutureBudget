//
//  TextFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextFieldEditInfo.h"
#import "TextFieldEditViewController.h"


@implementation TextFieldEditInfo

- (NSString*)detailTextLabel
{
    return [self.fieldInfo getFieldValue];
}

- (UIViewController*)fieldEditController
{
    TextFieldEditViewController *textEditController = 
    [[TextFieldEditViewController alloc] initWithNibName:@"TextFieldEditViewController"
                                            andFieldInfo:self.fieldInfo];
    [textEditController autorelease];
    return textEditController;    
}


@end
