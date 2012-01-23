//
//  TaxBracketEntryFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxBracketEntryFormInfoCreator.h"
#import "InputFormPopulator.h"
#import "LocalizationHelper.h"
#import "SharedAppValues.h"
#import "TaxBracketEntry.h"
#import "LocalizationHelper.h"


@implementation TaxBracketEntryFormInfoCreator

@synthesize taxBracketEntry;
@synthesize newEntry;

-(id)initWithTaxBracketEntry:(TaxBracketEntry*)theTaxBracketEntry
		andIsNewEntry:(BOOL)isNewEntry;
{
	self = [super init];
	if(self)
	{
		assert(theTaxBracketEntry != nil);
		self.taxBracketEntry = theTaxBracketEntry;
		
		self.newEntry = isNewEntry;
	}
	return self;
}

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.newEntry
			andParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"TAX_BRACKET_ENTRY_FORM_TITLE");
		
	[formPopulator nextSection];
	
	[formPopulator populateCurrencyField:self.taxBracketEntry 
		andValKey:TAX_BRACKET_ENTRY_CUTOFF_AMOUNT_KEY 
		andLabel:LOCALIZED_STR(@"TAX_BRACKET_ENTRY_CUTOFF_AMOUNT_LABEL") 
		andPlaceholder:LOCALIZED_STR(@"TAX_BRACKET_ENTRY_CUTOFF_AMOUNT_PLACEHOLDER")];

	[formPopulator populatePercentField:self.taxBracketEntry 
		andValKey:TAX_BRACKET_ENTRY_TAX_PERCENT_KEY 
			andLabel:LOCALIZED_STR(@"TAX_BRACKET_ENTRY_TAX_PERCENT_LABEL") 
			andPlaceholder:LOCALIZED_STR(@"TAX_BRACKET_ENTRY_TAX_PERCENT_PLACEHOLDER")];
		
	return formPopulator.formInfo;
	
}


-(void)dealloc
{
	[super dealloc];
	[taxBracketEntry release];
}

@end
