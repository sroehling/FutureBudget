//
//  StringValidation.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StringValidation.h"


@implementation StringValidation


+(BOOL)nonEmptyString:(NSString*)theString
{
    if(theString != nil &&
       [theString length] > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
