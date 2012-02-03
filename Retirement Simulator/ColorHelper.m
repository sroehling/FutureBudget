//
//  ColorHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ColorHelper.h"


@implementation ColorHelper

+ (UIColor*)blueTableTextColor
{
    return [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
}

+ (UIColor*)promptTextColor
{
    return [UIColor lightGrayColor];
}

+ (UIColor*)navBarTintColor
{
	return [UIColor blackColor];
}


+ (UIColor*)tableHeaderBackgroundColor
{
	return [UIColor colorWithWhite:0.5 alpha:0.5];
}

@end
