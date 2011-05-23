//
//  NumberHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberHelper.h"


@implementation NumberHelper

@synthesize numberFormatter;

+(NumberHelper*)theHelper
{  
    static NumberHelper *theNumberHelper;  
    @synchronized(self)  
    {    if(!theNumberHelper)      
        theNumberHelper =[[NumberHelper alloc] init];
        return theNumberHelper;
    }
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.numberFormatter = [[NSNumberFormatter alloc]init];
        [self.numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    return self;
}


- (BOOL)valueInRange:(NSInteger)value lower:(NSInteger)low upper:(NSInteger)up
{
    if((value >= low) && (value <= up))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString*)stringFromNumber:(NSNumber*)theNumber
{
    assert(theNumber != nil);
    return [self.numberFormatter stringFromNumber:theNumber];
}


-(void)dealloc
{
    [super dealloc];
    [numberFormatter release];
}


@end
