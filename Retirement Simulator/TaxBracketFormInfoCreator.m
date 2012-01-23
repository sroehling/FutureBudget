//
//  TaxBracketFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaxBracketFormInfoCreator.h"
#import "InputFormPopulator.h"
#import "SharedAppValues.h"
#import "Scenario.h"
#import "LocalizationHelper.h"
#import "TaxBracketEntryObjectAdder.h"
#import "TaxBracket.h"
#import "StaticNavFieldEditInfo.h"
#import "TaxBracketEntryFormInfoCreator.h"
#import "SectionInfo.h"
#import "DefaultScenario.h"
#import "NumberHelper.h"
#import "TaxBracketEntry.h"

@implementation TaxBracketFormInfoCreator

@synthesize taxBracket;

-(id)initWithTaxBracket:(TaxBracket *)theTaxBracket
{
	self = [super init];
	if(self)
	{
		assert(theTaxBracket != nil);
		self.taxBracket = theTaxBracket;
	}
	return self;
}

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{	
    InputFormPopulator *formPopulator = 
		[[[InputFormPopulator alloc] initForNewObject:FALSE
			andParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"TAX_BRACKET_FORM_TITLE");
	
	formPopulator.formInfo.objectAdder = [[[TaxBracketEntryObjectAdder alloc] 
		initWithTaxBracket:self.taxBracket] autorelease];
		
	SectionInfo *sectionInfo = [formPopulator nextSection];
	for(TaxBracketEntry *taxBracketEntry in self.taxBracket.taxBracketEntries)
	{
		TaxBracketEntryFormInfoCreator *taxBracketEntryFormInfoCreator
			= [[[TaxBracketEntryFormInfoCreator alloc] 
				initWithTaxBracketEntry:taxBracketEntry andIsNewEntry:FALSE] autorelease];
		
		NSString *cutoffAmountStr = [[NumberHelper theHelper] displayStrFromStoredVal:taxBracketEntry.cutoffAmount andFormatter:[NumberHelper theHelper].currencyFormatter];
		NSString *percentTaxStr = [[NumberHelper theHelper] displayStrFromStoredVal:taxBracketEntry.taxPercent andFormatter:[NumberHelper theHelper].percentFormatter];

		NSString *bracketEntryCaption = [NSString stringWithFormat:LOCALIZED_STR(@"TAX_BRACKET_ENTRY_LIST_FORMAT"),cutoffAmountStr];
		StaticNavFieldEditInfo *taxBracketEntryFieldEditInfo = 
			[[[StaticNavFieldEditInfo alloc] initWithCaption:bracketEntryCaption 
				andSubtitle:nil andContentDescription:percentTaxStr 
				andSubFormInfoCreator:taxBracketEntryFormInfoCreator] autorelease];
		taxBracketEntryFieldEditInfo.objectForDelete = taxBracketEntry;
		
		[sectionInfo addFieldEditInfo:taxBracketEntryFieldEditInfo];

	}

	return formPopulator.formInfo;
	
}


-(void)dealloc
{
	[super dealloc];
	[taxBracket release];
}

@end
