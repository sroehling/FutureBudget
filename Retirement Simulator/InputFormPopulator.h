//
//  InputFormHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormPopulator.h"
#import "ItemizedTaxAmtCreator.h"


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
@class TableHeaderWithDisclosure;
@class FormContext;
@class ItemizedTaxAmt;
@class ItemizedTaxAmtsInfo;
@class ItemizedTaxAmtsSelectionFormInfoCreator;
@class StaticNavFieldEditInfo;
@class Account;
@class MultiScenarioPercent;



@interface InputFormPopulator : FormPopulator {
    @private
		Scenario *inputScenario;
		BOOL isForNewObject;
}

@property(nonatomic,retain) Scenario *inputScenario;
@property BOOL isForNewObject;

-(id)initWithScenario:(Scenario*)theInputScenario andFormContext:(FormContext*)theFormContext;
-(id)initForNewObject:(BOOL)isNewObject andFormContext:(FormContext*)theFormContext;

- (void)populateInputNameField:(Input*)theInput withIconList:(NSArray*)inputIcons;

-(void)populateMultiScenBoolField:(MultiScenarioInputValue*)boolVal withLabel:(NSString*)label;
-(void)populateMultiScenBoolField:(MultiScenarioInputValue*)boolVal withLabel:(NSString*)label
	andSubtitle:(NSString*)subTitle; // subTitle is optional and can be nil for no subtitle

-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt
	andValidator:(NumberFieldValidator*)validator;
-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt 
		andObjectForDelete:(NSManagedObject*)objForDelete
		andValidator:(NumberFieldValidator*)validator;
	
-(void)populateCurrencyField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder;
-(void)populateCurrencyField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
	andSubtitle:(NSString*)subTitle;
	
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
- (void)populateMultiScenarioDividendReturnRate:(MultiScenarioGrowthRate*)dividendRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName;
- (void)populateMultiScenarioApprecRate:(MultiScenarioGrowthRate*)apprecRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName;
-(void)populateLoanDownPmtPercent:(LoanInput*)loan 
	withValueLabel:(NSString*)valueLabel
	andValueName:(NSString*)valueName;
- (void)populateMultiScenarioDividendReinvestPercent:(MultiScenarioPercent*)multiScenPercent
	withLabel:(NSString*)valueLabel 
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
-(void)populateLoanDeferPaymentDate:(LoanInput*)loan withFieldLabel:(NSString*)fieldLabel;
	
-(void)populateItemizedTaxForTaxAmtsInfo:(ItemizedTaxAmtsInfo*)itemizedTaxAmtsInfo
	andTaxAmt:(ItemizedTaxAmt*)itemizedTaxAmt
	andTaxAmtCreator:(id<ItemizedTaxAmtCreator>)taxAmtCreator;

-(StaticNavFieldEditInfo*)createItemizedTaxSelectionFieldEditInfoWithFieldLabel:(NSString*)fieldLabel
	andFormInfoCreator:(id<FormInfoCreator>)formInfoCreator
	andItemizedTaxAmtsInfo:(NSSet*)itemizedTaxAmts;
-(void)populateItemizedTaxSelectionWithFieldLabel:(NSString*)fieldLabel
	andFormInfoCreator:(id<FormInfoCreator>)formInfoCreator
	andItemizedTaxAmtsInfo:(NSSet*)itemizedTaxAmts;
-(void)populateItemizedTaxSelectionWithFieldLabel:(NSString*)fieldLabel
	andItemizedTaxAmtsFormInfoCreator:(ItemizedTaxAmtsSelectionFormInfoCreator *)formInfoCreator;

-(void)populateAcctWithdrawalOrderField:(Account*)account
	andFieldCaption:(NSString*)caption andFieldSubtitle:(NSString*)subtitle;

-(TableHeaderWithDisclosure*)scenarioListTableHeaderWithFormContext:(FormContext*)formContext;	
		
@end
