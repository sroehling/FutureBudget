//
//  DateFieldEditInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateFieldEditInfo.h"
#import "DateFieldEditViewController.h"


@implementation DateFieldEditInfo

@synthesize dateFormatter;


- (NSString*)detailTextLabel
{
    return [self.dateFormatter stringFromDate:[self.fieldInfo getFieldValue]];
}

- (UIViewController*)fieldEditController
{
    DateFieldEditViewController *dateController = 
        [[DateFieldEditViewController alloc] initWithNibName:@"DateFieldEditViewController"
                                                andFieldInfo:fieldInfo];
    [dateController autorelease];
    return dateController;

}

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}

- (void)dealloc {
    [super dealloc];
    [dateFormatter release];
}


@end
