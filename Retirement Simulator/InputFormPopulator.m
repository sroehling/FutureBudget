//
//  InputFormHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputFormPopulator.h"
#import "NumberFieldEditInfo.h"
#import "MultiScenarioFixedValueFieldInfo.h"
#import "NumberHelper.h"
#import "MultiScenarioInputValue.h"
#import "LocalizationHelper.h"
#import "SectionInfo.h"
#import "SharedAppValues.h"

#import "Scenario.h"
#import "DefaultScenario.h"

@implementation InputFormPopulator

@synthesize inputScenario;

-(id)initWithScenario:(Scenario*)theInputScenario
{
	self = [super init];
	if(self)
	{
		assert(theInputScenario != nil);
		self.inputScenario = theInputScenario;
	}
	return self;
}

-(id)initForNewObject:(BOOL)isNewObject
{
	Scenario *theInputScenario;
	if(isNewObject)
	{
		theInputScenario = [SharedAppValues singleton].defaultScenario;
	}
	else
	{
		theInputScenario = [SharedAppValues singleton].currentInputScenario;
	}
	return [self initWithScenario:theInputScenario];
}

-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt
{
	assert(inputVal != nil);
	MultiScenarioFixedValueFieldInfo *fieldInfo =
		[[[MultiScenarioFixedValueFieldInfo alloc] 
			initWithFieldLabel:label 
			andFieldPlaceholder:prompt
			andScenario:self.inputScenario  andInputVal:inputVal] autorelease];
   NumberFieldEditInfo *fieldEditInfo = 
		[[NumberFieldEditInfo alloc] initWithFieldInfo:fieldInfo
			andNumberFormatter:[NumberHelper theHelper].decimalFormatter];
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:fieldEditInfo];

}

-(void)populateCurrencyField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
{
	assert(parentObj != nil);
	assert(valKey != nil);
	
	NumberFieldEditInfo *currencyFieldEditInfo = 
			[NumberFieldEditInfo createForObject:parentObj andKey:valKey 
			andLabel:label
			andPlaceholder:placeholder
			andNumberFormatter:[NumberHelper theHelper].currencyFormatter];
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:currencyFieldEditInfo];
	
}

-(void)populatePercentField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
{
	assert(parentObj != nil);
	assert(valKey != nil);
	
	NumberFieldEditInfo *percentFieldEditInfo = 
			[NumberFieldEditInfo createForObject:parentObj 
				andKey:valKey andLabel:label andPlaceholder:placeholder
			andNumberFormatter:[NumberHelper theHelper].percentFormatter];
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:percentFieldEditInfo];
}


-(void)dealloc
{
	[super dealloc];
	[inputScenario release];
}	

@end
