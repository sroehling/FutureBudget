//
//  AlertViewHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertViewHelper.h"


@implementation AlertViewHelper

+(void)leftAlignAlertViewText:(UIAlertView*)av
{
	assert(av != nil);
	// This is a little bit of a hack. We will eventually want to show an alert view with rich text,
	// but the code fragment below will suffice to left align the text in the alert view.
	NSArray *subViewArray = av.subviews;
	for(int x=0;x<[subViewArray count];x++)
	{
		if([[[subViewArray objectAtIndex:x] class] 
			isSubclassOfClass:[UILabel class]])
		{
			UILabel *sublabel = [subViewArray objectAtIndex:x];
			sublabel.textAlignment = UITextAlignmentLeft;
		}

	}
}

@end
