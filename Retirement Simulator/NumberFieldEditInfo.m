//
//  NumberFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberFieldEditInfo.h"
#import "NumberFieldEditViewController.h"


@implementation NumberFieldEditInfo


@synthesize numberFormatter;

- (NSString*)detailTextLabel
{
    return [self.numberFormatter stringFromNumber:[self.fieldInfo getFieldValue]];
    
}

- (UIViewController*)fieldEditController
{
    NumberFieldEditViewController *numberController = 
    [[NumberFieldEditViewController alloc] initWithNibName:@"NumberFieldEditViewController" 
                                              andFieldInfo:self.fieldInfo];
    [numberController autorelease];
    return numberController;
    
}

- (NSNumberFormatter *)numberFormatter
{
    if (numberFormatter == nil)
    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return numberFormatter;
}

- (void)dealloc {
    [super dealloc];
    [numberFormatter release];
}





@end
