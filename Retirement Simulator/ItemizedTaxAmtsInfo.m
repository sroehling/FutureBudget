//
//  ItemizedTaxAmtsInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtsInfo.h"


@implementation ItemizedTaxAmtsInfo

@synthesize itemizedTaxAmts;
@synthesize title;
@synthesize amtPrompt;
@synthesize itemTitle;

-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts 
	andTitle:(NSString*)theTitle andAmtPrompt:(NSString *)theAmtPrompt
	andItemTitle:(NSString*)theItemTitle
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmts != nil);
		assert(theTitle != nil);
		assert(theAmtPrompt != nil);
		self.itemizedTaxAmts = theItemizedTaxAmts;
		self.title = theTitle;
		self.amtPrompt = theAmtPrompt;
		self.itemTitle = theItemTitle;
		
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

-(void)dealloc
{
	[super dealloc];
	[title release];
	[itemizedTaxAmts release];
	[amtPrompt release];
	[itemTitle release];
}


@end
