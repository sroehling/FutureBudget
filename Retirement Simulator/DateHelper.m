//
//  DateHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateHelper.h"


@implementation DateHelper

@synthesize mediumDateFormatter;

+(DateHelper*)theHelper
{  
    static DateHelper *theDateHelper;  
    @synchronized(self)  
    {    if(!theDateHelper)      
        theDateHelper =[[DateHelper alloc] init];
        return theDateHelper;
    }
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.mediumDateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [self.mediumDateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[self.mediumDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return self;
}



+ (NSDate*)today
{
    return [[[NSDate alloc] init]autorelease];
}

- (void) dealloc
{
    [super dealloc];
    [mediumDateFormatter release];
}

@end
