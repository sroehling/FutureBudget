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

@synthesize itemizeIncomes;
@synthesize itemizeExpenses;
@synthesize itemizeAccountContribs;
@synthesize itemizeAccountWithdrawals;
@synthesize itemizeAccountInterest;
@synthesize itemizeLoanInterest;
@synthesize itemizeAssetGains;


-(id)initWithItemizedTaxAmts:(ItemizedTaxAmts*)theItemizedTaxAmts 
	andTitle:(NSString*)theTitle andAmtPrompt:(NSString *)theAmtPrompt
	andItemTitle:(NSString*)theItemTitle
	andItemizeIncomes:(BOOL)doItemizeIncomes
	andItemizeExpenses:(BOOL)doItemizeExpenses
	andItemizeAccountContribs:(BOOL)doItemizeAcctContribs
	andItemizeAccountWithdrawals:(BOOL)doItemizeAcctWithdrawals
	andItemizeAccountInterest:(BOOL)doItemizeAcctInterest
	andItemizeAssetGains:(BOOL)doItemizeAssetGains
	andItemizeLoanInterest:(BOOL)doItemizeLoanInterest
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
		
		self.itemizeIncomes = doItemizeIncomes;
		self.itemizeExpenses = doItemizeExpenses;
		self.itemizeAccountContribs = doItemizeAcctContribs;
		self.itemizeAccountWithdrawals = doItemizeAcctWithdrawals;
		self.itemizeAccountInterest = doItemizeAcctInterest;
		self.itemizeAssetGains = doItemizeAssetGains;
		self.itemizeLoanInterest = doItemizeLoanInterest;
		
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
