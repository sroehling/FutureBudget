//
//  NumberHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NumberHelper.h"


@implementation NumberHelper
@synthesize decimalFormatter;
@synthesize currencyFormatter;
@synthesize percentFormatter;

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

        self.decimalFormatter = [[[NSNumberFormatter alloc]init] autorelease];
        [self.decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
 		[self.decimalFormatter setMinimumFractionDigits:0];
		[self.decimalFormatter setMaximumFractionDigits:3];
     
        self.currencyFormatter = [[[NSNumberFormatter alloc]init] autorelease];
        [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[self.currencyFormatter setMinimumFractionDigits:0];
		[self.currencyFormatter setMaximumFractionDigits:2];

        self.percentFormatter = [[[NSNumberFormatter alloc]init] autorelease];
		// Using the multiplier of 100 allows people to enter values like 5 to mean 5%
		// rather than having to enter .05.
		
        [self.percentFormatter setNumberStyle:NSNumberFormatterPercentStyle];
		[self.percentFormatter setMinimumFractionDigits:0];
		[self.percentFormatter setMaximumFractionDigits:3];

        
        
    }
    return self;
}

- (NSNumber*)displayValFromStoredVal:(NSNumber*)storedVal andFormatter:(NSNumberFormatter*)formatter
{
	assert(storedVal != nil);
	assert(formatter != nil);
	NSNumber *displayVal;
	if(formatter.numberStyle == NSNumberFormatterPercentStyle)
	{
		displayVal = [NSNumber numberWithDouble:[storedVal doubleValue]/100.0];
	}
	else
	{
		displayVal = storedVal;
	}
	return displayVal;
}

- (NSString*)displayStrFromStoredVal:(NSNumber*)storedVal andFormatter:(NSNumberFormatter*)formatter
{
	NSNumber *displayVal = [self displayValFromStoredVal:storedVal andFormatter:formatter];
	return [formatter stringFromNumber:displayVal];
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
    return [self.decimalFormatter stringFromNumber:theNumber];
}


-(void)dealloc
{
    [decimalFormatter release];
	[percentFormatter release];
	[currencyFormatter release];
    [super dealloc];
}


@end
