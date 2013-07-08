//
//  TestTaxBracket.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/5/13.
//
//

#import "TestTaxBracket.h"
#import "DateHelper.h"
#import "DataModelController.h"
#import "SharedAppValues.h"
#import "TaxInputTypeSelectionInfo.h"
#import "InputCreationHelper.h"
#import "TaxInput.h"
#import "TaxBracketEntry.h"
#import "TaxBracket.h"

@implementation TestTaxBracket

@synthesize coreData;
@synthesize sharedAppVals;
@synthesize taxCreator;

- (void)resetCoreData
{
	self.coreData = [[[DataModelController alloc] initForInMemoryStorage] autorelease];
	self.sharedAppVals = [SharedAppValues createWithDataModelInterface:self.coreData];
	
	self.sharedAppVals.simStartDate = [DateHelper dateFromStr:@"2012-01-01"];
	
	InputCreationHelper *inputCreationHelper = [[[InputCreationHelper alloc]
		initWithDataModelController:self.coreData
		andSharedAppVals:self.sharedAppVals] autorelease];

	
	self.taxCreator =
		[[[TaxInputTypeSelectionInfo alloc]
		initWithInputCreationHelper:inputCreationHelper
		andDataModelController:self.coreData andLabel:@""
		andSubtitle:@"" andImageName:nil] autorelease];

	
}

-(void)addTaxBracketEntry:(TaxInput*)taxInput withCutoffAmount:(double)cutoff
	andTaxPercent:(double)taxPercent
{
	TaxBracketEntry *taxEntry = [self.coreData insertObject:TAX_BRACKET_ENTRY_ENTITY_NAME];
	taxEntry.cutoffAmount = [NSNumber numberWithDouble:cutoff];
					
	taxEntry.taxPercent = [self.taxCreator.inputCreationHelper multiScenGrowthRateWithDefault:taxPercent];;
	[taxInput.taxBracket addTaxBracketEntriesObject:taxEntry];
}

-(void)checkTaxBracketSummary:(TaxInput*)taxInput andExpectedSummary:(NSString*)expectedSummary
{
	NSString *actualSummary = [taxInput.taxBracket taxBracketSummaryForScenario:self.sharedAppVals.currentInputScenario
		andDate:self.sharedAppVals.simStartDate];
	
	NSLog(@"Tax Bracket Summary %@",actualSummary);
	
	STAssertEqualObjects(expectedSummary,actualSummary,
		@"checkTaxBracketSummary: Expecting summary '%@', got '%@'",
				expectedSummary,actualSummary);
}

-(void)testTaxBracketSummary
{
	[self resetCoreData];
	
	TaxInput *noTax = (TaxInput*)[self.taxCreator createInput];
	[self checkTaxBracketSummary:noTax
		andExpectedSummary:@"0% tax (no tax bracket entries defined)"];
	
	TaxInput *flatTax = (TaxInput*)[self.taxCreator createInput];
	[self addTaxBracketEntry:flatTax withCutoffAmount:0.0 andTaxPercent:25.0];
	[self checkTaxBracketSummary:flatTax
		andExpectedSummary:@"25% flat/effective rate (same tax percent for all amounts)"];


	TaxInput *undefinedInitialTaxThenFlatTax = (TaxInput*)[self.taxCreator createInput];
	// No tax is defined until $1000. The results should be to show 0% tax for the first $1000
	[self addTaxBracketEntry:undefinedInitialTaxThenFlatTax withCutoffAmount:1000.0 andTaxPercent:20.0];
	[self checkTaxBracketSummary:undefinedInitialTaxThenFlatTax
		andExpectedSummary:@"0% for the first $1,000, 20% for amounts above $1,000"];
			
	TaxInput *undefinedInitialTaxThenProgressive = (TaxInput*)[self.taxCreator createInput];
	// No tax is defined until $1000. The results should be to show 0% tax for the first $1000
	[self addTaxBracketEntry:undefinedInitialTaxThenProgressive withCutoffAmount:1000.0 andTaxPercent:20.0];
	[self addTaxBracketEntry:undefinedInitialTaxThenProgressive withCutoffAmount:2000.0 andTaxPercent:40.0];
	[self checkTaxBracketSummary:undefinedInitialTaxThenProgressive
		andExpectedSummary:@"0% for the first $1,000, 20% for amounts above $1,000, 40% for amounts above $2,000"];


	TaxInput *progressiveTax = (TaxInput*)[self.taxCreator createInput];
	// No tax is defined until $1000. The results should be to show 0% tax for the first $1000
	[self addTaxBracketEntry:progressiveTax withCutoffAmount:0.0 andTaxPercent:20.0];
	[self addTaxBracketEntry:progressiveTax withCutoffAmount:2000.0 andTaxPercent:40.0];
	[self addTaxBracketEntry:progressiveTax withCutoffAmount:3000.0 andTaxPercent:60.0];
	[self checkTaxBracketSummary:progressiveTax
		andExpectedSummary:@"20% for the first $2,000, 40% for amounts above $2,000, 60% for amounts above $3,000"];
			
			
}

- (void)setUp
{
	[self resetCoreData];
}

- (void)tearDown
{
	[coreData release];
	[sharedAppVals release];
	[taxCreator release];
}



@end
