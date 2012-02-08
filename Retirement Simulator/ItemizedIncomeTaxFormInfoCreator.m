//
//  ItemizedIncomeTaxFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemizedIncomeTaxFormInfoCreator.h"

#import "InputFormPopulator.h"
#import "SectionInfo.h"
#import "ItemizedTaxAmtsInfo.h"
#import "LocalizationHelper.h"
#import "DataModelController.h"
#import "TaxInput.h"
#import "ItemizedTaxAmtFieldPopulator.h"
#import "ItemizedTaxAmts.h"
#import "ItemizedIncomeTaxAmtCreator.h"
#import "ItemizedTaxAmtFieldEditInfo.h"
#import "IncomeItemizedTaxAmt.h"


@implementation ItemizedIncomeTaxFormInfoCreator

@synthesize income;
@synthesize isForNewObject;

-(id)initWithIncome:(IncomeInput*)theIncome andIsForNewObject:(BOOL)forNewObject
{
	self = [super init];
	if(self)
	{
		assert(theIncome != nil);
		self.income = theIncome;
		
		self.isForNewObject = forNewObject;
	}
	return self;
}

- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
	
    InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] 
		initForNewObject:self.isForNewObject
			andParentController:parentController] autorelease];
			
	formPopulator.formInfo.title = LOCALIZED_STR(@"INPUT_INCOME_ITEMIZED_TAXES_FORM_TITLE");
	
	NSSet *inputs = [[DataModelController theDataModelController] 
			fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME];
	if([inputs count] > 0)
	{
		[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"INPUT_INCOME_TAXABLE_SECTION_TITLE")];
		for(TaxInput *tax in inputs)
		{
			ItemizedTaxAmtsInfo *taxSourceInfo = [ItemizedTaxAmtsInfo taxSourceInfo:tax];
			[formPopulator populateItemizedTaxForTaxAmtsInfo:taxSourceInfo 
				andTaxAmt:[taxSourceInfo.fieldPopulator findItemizedIncome:self.income] 
				andTaxAmtCreator:[[[ItemizedIncomeTaxAmtCreator alloc] 
					initWithIncome:self.income andItemLabel:tax.name] autorelease]];
		}
	}

	return formPopulator.formInfo;
	
}


-(void)dealloc
{
	[super dealloc];
	[income release];
}

@end
