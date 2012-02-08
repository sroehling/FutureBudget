//
//  ItemizedTaxAmtsInfo.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTaxAmtsInfo.h"

#import "StringValidation.h"
#import "ItemizedTaxAmts.h"
#import "LocalizationHelper.h"
#import "ItemizedTaxAmtFieldPopulator.h"
#import "TaxInput.h"

@implementation ItemizedTaxAmtsInfo

@synthesize itemizedTaxAmts;
@synthesize title;
@synthesize amtPrompt;
@synthesize itemTitle;
@synthesize itemSectionTitleFormat;
@synthesize itemHelpInfoFile;
@synthesize fieldPopulator;


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
	andItemSectionTitleFormat:(NSString*)theItemSectionTitleFormat
	andItemHelpInfoFile:(NSString*)theItemHelpFile
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
		
		assert([StringValidation nonEmptyString:theItemSectionTitleFormat]);
		self.itemSectionTitleFormat = theItemSectionTitleFormat;
		
		assert([StringValidation nonEmptyString:theItemHelpFile]);
		self.itemHelpInfoFile = theItemHelpFile;
		
		self.itemizeIncomes = doItemizeIncomes;
		self.itemizeExpenses = doItemizeExpenses;
		self.itemizeAccountContribs = doItemizeAcctContribs;
		self.itemizeAccountWithdrawals = doItemizeAcctWithdrawals;
		self.itemizeAccountInterest = doItemizeAcctInterest;
		self.itemizeAssetGains = doItemizeAssetGains;
		self.itemizeLoanInterest = doItemizeLoanInterest;
		
		self.fieldPopulator = [[[ItemizedTaxAmtFieldPopulator alloc] 
					initWithItemizedTaxAmts:itemizedTaxAmts] autorelease];
		
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}


+(ItemizedTaxAmtsInfo*)taxSourceInfo:(TaxInput*)tax
{
	assert(tax != nil);
	return [[[ItemizedTaxAmtsInfo alloc] 
			initWithItemizedTaxAmts:tax.itemizedIncomeSources 
			andTitle:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_SOURCES_TITLE")
			andAmtPrompt:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_SOURCES_AMOUNT_PROMPT")
			andItemTitle:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_SOURCE_ITEM_TITLE")
			andItemSectionTitleFormat:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_SOURCE_TITLE_FORMAT")
			andItemHelpInfoFile:@"taxSource"		
			andItemizeIncomes:				TRUE 
			andItemizeExpenses:				FALSE 
			andItemizeAccountContribs:		FALSE 
			andItemizeAccountWithdrawals:	TRUE 
			andItemizeAccountInterest:		TRUE 
			andItemizeAssetGains:			TRUE 
			andItemizeLoanInterest:			FALSE] autorelease];
}


+(ItemizedTaxAmtsInfo*)taxAdjustmentInfo:(TaxInput*)tax
{
	return [[[ItemizedTaxAmtsInfo alloc] 
			initWithItemizedTaxAmts:tax.itemizedAdjustments 
			andTitle:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ADJUSTMENTS_TITLE")
			andAmtPrompt:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ADJUSTMENTS_AMOUNT_PROMPT")
			andItemTitle:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ADJUSTMENT_ITEM_TITLE")
			andItemSectionTitleFormat:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_ADJUSTMENT_TITLE_FORMAT")
			andItemHelpInfoFile:@"taxAdjustment" 		
			andItemizeIncomes:				FALSE 
			andItemizeExpenses:				TRUE 
			andItemizeAccountContribs:		TRUE 
			andItemizeAccountWithdrawals:	FALSE 
			andItemizeAccountInterest:		FALSE 
			andItemizeAssetGains:			FALSE 
			andItemizeLoanInterest:			TRUE] autorelease];
}

+(ItemizedTaxAmtsInfo*)taxDeductionInfo:(TaxInput*)tax

{
	return[[[ItemizedTaxAmtsInfo alloc] 
			initWithItemizedTaxAmts:tax.itemizedDeductions 
			andTitle:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_DEDUCTIONS_TITLE")
			andAmtPrompt:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_DEDUCTIONS_AMOUNT_PROMPT")
			andItemTitle:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_DEDUCTION_ITEM_TITLE")
			andItemSectionTitleFormat:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_DEDUCTION_TITLE_FORMAT")
			andItemHelpInfoFile:@"taxDeduction"  		
			andItemizeIncomes:				FALSE 
			andItemizeExpenses:				TRUE 
			andItemizeAccountContribs:		TRUE 
			andItemizeAccountWithdrawals:	FALSE 
			andItemizeAccountInterest:		FALSE 
			andItemizeAssetGains:			FALSE 
			andItemizeLoanInterest:			TRUE] autorelease];
}

+(ItemizedTaxAmtsInfo*)taxCreditInfo:(TaxInput*)tax
{
	return [[[ItemizedTaxAmtsInfo alloc] 
			initWithItemizedTaxAmts:tax.itemizedCredits 
			andTitle:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_CREDITS_TITLE")
			andAmtPrompt:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_CREDITS_AMOUNT_PROMPT")
			andItemTitle:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_CREDIT_ITEM_TITLE")
			andItemSectionTitleFormat:LOCALIZED_STR(@"INPUT_TAX_ITEMIZED_CREDIT_TITLE_FORMAT")
			andItemHelpInfoFile:@"taxCredit" 	
			andItemizeIncomes:				FALSE 
			andItemizeExpenses:				TRUE 
			andItemizeAccountContribs:		TRUE 
			andItemizeAccountWithdrawals:	FALSE 
			andItemizeAccountInterest:		FALSE 
			andItemizeAssetGains:			FALSE 
			andItemizeLoanInterest:			TRUE] autorelease];
}

-(void)dealloc
{
	[super dealloc];
	[title release];
	[itemHelpInfoFile release];
	[itemSectionTitleFormat release];
	[itemizedTaxAmts release];
	[amtPrompt release];
	[itemTitle release];
	[fieldPopulator release];
}


@end
