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
#import "FormContext.h"
#import "CollectionHelper.h"
#import "SimInputHelper.h"
#import "SharedAppValues.h"
#import "MultiScenarioGrowthRate.h"

@implementation TaxBracketFormInfoCreator

@synthesize taxBracket;

-(id)initWithTaxBracket:(TaxBracket *)theTaxBracket andIsForNewObject:(BOOL)bracketIsForNewObject
{
	self = [super init];
	if(self)
	{
		assert(theTaxBracket != nil);
		self.taxBracket = theTaxBracket;
		isForNewObject = bracketIsForNewObject;
	}
	return self;
}

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext
{	
    InputFormPopulator *formPopulator = 
		[[[InputFormPopulator alloc] initForNewObject:isForNewObject
			andFormContext:parentContext] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"TAX_BRACKET_FORM_TITLE");
	
	formPopulator.formInfo.objectAdder = [[[TaxBracketEntryObjectAdder alloc] 
		initWithTaxBracket:self.taxBracket andParentDataModelController:parentContext.dataModelController] autorelease];
		
	SectionInfo *sectionInfo = [formPopulator nextSection];
	
	NSArray *sortedTaxBracketEntries = [CollectionHelper
			setToSortedArray:self.taxBracket.taxBracketEntries
			withKey:TAX_BRACKET_ENTRY_CUTOFF_AMOUNT_KEY];
	
	for(TaxBracketEntry *taxBracketEntry in sortedTaxBracketEntries)
	{
		TaxBracketEntryFormInfoCreator *taxBracketEntryFormInfoCreator
			= [[[TaxBracketEntryFormInfoCreator alloc] 
				initWithTaxBracketEntry:taxBracketEntry andIsNewEntry:FALSE] autorelease];
		
		NSString *cutoffAmountStr = [[NumberHelper theHelper] displayStrFromStoredVal:taxBracketEntry.cutoffAmount andFormatter:[NumberHelper theHelper].currencyFormatter];
		
		
		SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:parentContext.dataModelController];
		double storedTaxRate = [SimInputHelper multiScenValueAsOfDate:taxBracketEntry.taxPercent.growthRate
				andDate:sharedAppVals.simStartDate andScenario:formPopulator.inputScenario];
		NSNumber *storedTaxPerc = [NSNumber numberWithDouble:storedTaxRate];
		NSString *percentTaxStr = [[NumberHelper theHelper] displayStrFromStoredVal:storedTaxPerc andFormatter:[NumberHelper theHelper].percentFormatter];

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
	[taxBracket release];
	[super dealloc];
}

@end
