//
//  UIHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIHelper.h"


@implementation UIHelper

+(UILabel*)titleForNavBar
{
	UILabel *titleView = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	titleView.backgroundColor = [UIColor clearColor];
	titleView.font = [UIFont boldSystemFontOfSize:17.0];
	titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	titleView.textColor = [UIColor whiteColor]; // Change to desired color
	return titleView;
}

@end
