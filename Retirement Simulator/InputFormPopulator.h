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
@class NumberFieldValidator;
@class LoanInput;
@class VariableValue;

@interface InputFormPopulator : FormPopulator {
    @private
		Scenario *inputScenario;
}

@property(nonatomic,retain) Scenario *inputScenario;

-(id)initWithScenario:(Scenario*)theInputScenario andParentController:(UIViewController*)parentController;
-(id)initForNewObject:(BOOL)isNewObject andParentController:(UIViewController*)parentController;

- (void)populateInputNameField:(Input*)theInput;

-(void)populateMultiScenBoolField:(MultiScenarioInputValue*)boolVal withLabel:(NSString*)label;

-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt
	andValidator:(NumberFieldValidator*)validator;
-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt 
		andObjectForDelete:(NSManagedObject*)objForDelete
		andValidator:(NumberFieldValidator*)validator;
	
-(void)populateCurrencyField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder;
	
-(void)populatePercentField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder;
-(void)populateMultiScenPercentField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt 
	andAllowGreaterThan100Percent:(BOOL)allowGreaterThan100;
	
	
-(void)populateMultiScenarioAmount:(MultiScenarioAmount*)theAmount 
	withValueTitle:(NSString*)valueTitle andValueName:(NSString*)valueName;
	
-(void)populateMultiScenarioGrowthRate:(MultiScenarioGrowthRate*)growthRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName;
-(void)populateSingleScenarioVariableValue:(VariableValue*)growthRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName;
	
- (void)populateMultiScenarioInterestRate:(MultiScenarioGrowthRate*)intRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName;	
- (void)populateMultiScenarioInvestmentReturnRate:(MultiScenarioGrowthRate*)roiRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName;
- (void)populateMultiScenarioApprecRate:(MultiScenarioGrowthRate*)apprecRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName;
-(void)populateLoanDownPmtPercent:(LoanInput*)loan 
	withValueLabel:(NSString*)valueLabel
	andValueName:(NSString*)valueName;
	
-(RepeatFrequencyFieldEditInfo*)populateRepeatFrequency:(MultiScenarioInputValue*)repeatFreq
	andLabel:(NSString*)label;
		
-(void)populateMultiScenarioDuration:(MultiScenarioInputValue*)duration 
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder;
	
-(void)populateMultiScenSimDate:(MultiScenarioSimDate*)multiScenSimDate 
	andLabel:(NSString*)label andTitle:(NSString*)title
	andTableHeader:(NSString*)tableHeader andTableSubHeader:(NSString*)tableSubHeader;

-(void)populateMultiScenSimEndDate:(MultiScenarioSimEndDate*)multiScenSimEndDate 
	andLabel:(NSString*)label andTitle:(NSString*)title 
	andTableHeader:(NSString*)tableHeader andTableSubHeader:(NSString*)tableSubHeader
	andNeverEndFieldTitle:(NSString*)neverEndFieldTitle
	andNeverEndFieldSubtitle:(NSString*)neverEndFieldSubTitle
	andNeverEndSectionTitle:(NSString*)neverEndSectionTitle
	andNeverEndHelpInfo:(NSString*)neverEndHelpFile
	andRelEndDateSectionTitle:(NSString*)relEndDateSectionTitle
	andRelEndDateHelpFile:(NSString*)relEndDateHelpFile
	andRelEndDateFieldLabel:(NSString*)relEndDateFieldLabel;
		
@end
