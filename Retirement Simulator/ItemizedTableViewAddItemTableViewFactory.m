//
//  ItemizedTableViewAddItemTableViewFactory.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemizedTableViewAddItemTableViewFactory.h"
#import "GenericFieldBasedTableAddViewController.h"
#import "StaticFormInfoCreator.h"
#import "FormPopulator.h"
#import "ItemizedTaxAmt.h"
#import "LocalizationHelper.h"
#import "SharedAppValues.h"
#import "Scenario.h"
#import "InputFormPopulator.h"
#import "ItemizedTaxAmtsInfo.h"
#import "DefaultScenario.h"
#import "ItemizedTaxAmtCreator.h"
#import "FinishedAddingItemizedTaxAmtListener.h"
#import "PercentFieldValidator.h"

@implementation ItemizedTableViewAddItemTableViewFactory

@synthesize itemizedTaxAmtsInfo;
@synthesize itemizedTaxAmtCreator;

-(id)initWithItemizedTaxAmtsInfo:(ItemizedTaxAmtsInfo*)theItemizedTaxAmtsInfo andItemizedTaxAmtCreator:(id<ItemizedTaxAmtCreator>)theTaxAmtCreator
{
	self = [super init];
	if(self)
	{
		assert(theItemizedTaxAmtsInfo != nil);
		self.itemizedTaxAmtsInfo = theItemizedTaxAmtsInfo;
		
		assert(theTaxAmtCreator);
		self.itemizedTaxAmtCreator = theTaxAmtCreator;
	}
	return self;
}

-(id)init
{
	assert(0); // must call init selector above
	return nil;
}

- (UIViewController*)createTableView
{
	Scenario *defaultScenario = [SharedAppValues singleton].defaultScenario;
	InputFormPopulator *formPopulator = [[[InputFormPopulator alloc] initWithScenario:defaultScenario] autorelease];
	
	ItemizedTaxAmt *itemization = [self.itemizedTaxAmtCreator createItemizedTaxAmt];
	assert(itemization != nil);
	
	formPopulator.formInfo.title = self.itemizedTaxAmtsInfo.itemTitle;
	
	[formPopulator nextSection];
	[formPopulator populateMultiScenFixedValField:itemization.multiScenarioApplicablePercent andValLabel:self.itemizedTaxAmtsInfo.amtPrompt 
		andPrompt:self.itemizedTaxAmtsInfo.amtPrompt
		andValidator:[[[PercentFieldValidator alloc] init] autorelease]];
	
    GenericFieldBasedTableAddViewController *controller = 
		[[[GenericFieldBasedTableAddViewController alloc]
			initWithFormInfoCreator:[StaticFormInfoCreator 
			createWithFormInfo:formPopulator.formInfo] 
			andNewObject:itemization] autorelease];
	controller.finshedAddingListener = 
		[[[FinishedAddingItemizedTaxAmtListener alloc] initWithItemizedTaxAmts:self.itemizedTaxAmtsInfo.itemizedTaxAmts] autorelease];
    controller.popDepth =2;
    return controller;
}

- (void)dealloc
{
	[super dealloc];
	[itemizedTaxAmtsInfo release];
	[itemizedTaxAmtCreator release];
}





@end
