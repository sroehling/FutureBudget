//
//  InputFormHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormPopulator.h"

@class Input;
@class MultiScenarioInputValue;
@class MultiScenarioAmount;
@class MultiScenarioGrowthRate;
@class SectionInfo;
@class Scenario;
@class RepeatFrequencyFieldEditInfo;
@class MultiScenarioSimDate;
@class MultiScenarioSimEndDate;

@interface InputFormPopulator : FormPopulator {
    @private
		Scenario *inputScenario;
}

@property(nonatomic,retain) Scenario *inputScenario;

-(id)initWithScenario:(Scenario*)theInputScenario;
-(id)initForNewObject:(BOOL)isNewObject;

- (void)populateInputNameField:(Input*)theInput;

-(void)populateMultiScenBoolField:(MultiScenarioInputValue*)boolVal withLabel:(NSString*)label;

-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt;
	
-(void)populateCurrencyField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder;
	
-(void)populatePercentField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder;
	
-(void)populateMultiScenarioAmount:(MultiScenarioAmount*)theAmount 
	withValueTitle:(NSString*)valueTitle;
-(void)populateMultiScenarioGrowthRate:(MultiScenarioGrowthRate*)growthRate
	withLabel:(NSString*)valueLabel;
	
-(RepeatFrequencyFieldEditInfo*)populateRepeatFrequency:(NSManagedObject*)parentObj 
		andFreqKey:(NSString*)freqKey andLabel:(NSString*)label;
		
-(void)populateMultiScenarioDuration:(MultiScenarioInputValue*)duration 
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder;
	
-(void)populateMultiScenSimDate:(MultiScenarioSimDate*)multiScenSimDate 
	andLabel:(NSString*)label andTitle:(NSString*)title;
-(void)populateMultiScenSimEndDate:(MultiScenarioSimEndDate*)multiScenSimEndDate 
	andLabel:(NSString*)label andTitle:(NSString*)title;
	
@end
