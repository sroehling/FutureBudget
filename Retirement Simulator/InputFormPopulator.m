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

#import "ManagedObjectFieldInfo.h"
#import "NameFieldEditInfo.h"
#import "Input.h"

#import "Scenario.h"
#import "DefaultScenario.h"

#import "MultiScenarioBoolInputValueFieldInfo.h"
#import "BoolFieldEditInfo.h"

#import "MultiScenarioAmount.h"
#import "MultiScenarioAmountVariableValueListMgr.h"
#import "VariableValueRuntimeInfo.h"
#import "DateSensitiveValueFieldEditInfo.h"

#import "SharedEntityVariableValueListMgr.h"
#import "MultiScenarioGrowthRate.h"
#import "InflationRate.h"

#import "RepeatFrequencyFieldEditInfo.h"
#import "StringValidation.h"

#import "DurationFieldEditInfo.h"

#import "SimDateFieldEditInfo.h"
#import "SimDateRuntimeInfo.h"

#import "MultiScenarioSimDate.h"
#import "MultiScenarioSimEndDate.h"

#import "PercentFieldValidator.h"
#import "GrowthRateFieldValidator.h"
#import "PositiveAmountValidator.h"
#import "InterestRate.h"
#import "InvestmentReturnRate.h"
#import "AssetApprecRate.h"
#import "LoanDownPmtPercent.h"
#import "LoanInput.h"
#import "VariableValueFieldEditInfo.h"
#import "UpTo100PercentFieldValidator.h"
#import "TableHeaderWithDisclosure.h"
#import "SelectScenarioTableHeaderButtonDelegate.h"
#import "MultipleSelectionTableViewControllerFactory.h"
#import "StaticNavFieldEditInfo.h"

#import "ItemizedTaxAmtsInfo.h"
#import "ItemizedTaxAmts.h"
#import "ItemizedTaxAmtCreator.h"
#import "ItemizedTaxAmtFieldEditInfo.h"
#import "FormContext.h"
#import "NameFieldCell.h"
#import "ItemizedTaxAmtsSelectionFormInfoCreator.h"

#import "InputNameValidator.h"
#import "ItemizedTaxAmt.h"
#import "ItemizedTaxAmts.h"
#import "TaxInput.h"
#import "MultiScenarioPercent.h"

#import "AccountWithdrawalOrderInfo.h"
#import "AccountWithdrawalOrderFieldEditInfo.h"

#import "DividendRate.h"
#import "DividendReinvestPercent.h"
#import "BoolFieldShowHideCondition.h"
#import "BoolFieldCell.h"
#import "TaxRate.h"

@implementation InputFormPopulator

@synthesize inputScenario;
@synthesize isForNewObject;

-(id)initWithScenario:(Scenario*)theInputScenario andFormContext:(FormContext*)theFormContext
{
	self = [super initWithFormContext:theFormContext];
	if(self)
	{
		assert(theInputScenario != nil);
		self.inputScenario = theInputScenario;
		
		self.isForNewObject = FALSE;
	}
	return self;
}

-(id)initForNewObject:(BOOL)isNewObject andFormContext:(FormContext*)theFormContext
{
	self = [super initWithFormContext:theFormContext];
	if(self)
	{
		SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:theFormContext.dataModelController];
		if(isNewObject)
		{
			self.inputScenario = sharedAppVals.defaultScenario;
		}
		else
		{
			self.inputScenario = sharedAppVals.currentInputScenario;
		}
	}
	self.isForNewObject = isNewObject;
	return self;
}


-(id)init
{
	assert(0);
	return nil;
}


- (void)populateInputNameField:(Input*)theInput withIconList:(NSArray*)inputIcons
{
   [self nextSection];
   
   assert(theInput!=nil);
   assert(inputIcons != nil);
   assert(inputIcons.count > 0);
	
	ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc] 
		initWithManagedObject:theInput 
		andFieldKey:INPUT_NAME_KEY 
		andFieldLabel:LOCALIZED_STR(@"INPUT_NAME_FIELD_LABEL")
		andFieldPlaceholder:LOCALIZED_STR(@"INPUT_NAME_PLACEHOLDER")] autorelease];
		
	ManagedObjectFieldInfo *imageFieldInfo = [[[ManagedObjectFieldInfo alloc]
		initWithManagedObject:theInput 
		andFieldKey:INPUT_ICON_IMAGE_NAME_KEY
		andFieldLabel:@"N/A" andFieldPlaceholder:@"N/A"] autorelease];

		
	InputNameValidator *uniqueNameValidator = [[[InputNameValidator alloc]
		initWithInput:theInput andDataModelController:self.formContext.dataModelController] autorelease];
		
	NameFieldEditInfo *fieldEditInfo = [[[NameFieldEditInfo alloc] 
		initWithFieldInfo:fieldInfo andCustomValidator:uniqueNameValidator
			andParentController:self.formContext.parentController
			andImageNames:inputIcons andImageFieldInfo:imageFieldInfo] autorelease];
			
	// When first prompting for the name, make the name field the first
	// responder.
	if(![fieldInfo fieldIsInitializedInParentObject])
	{
		self.formInfo.firstResponder = fieldEditInfo.cell.textField;
	}
	
    [self.currentSection addFieldEditInfo:fieldEditInfo];

}

// Multi Scenario Boolean Field methods

-(BoolFieldEditInfo*)multiScenBoolFieldEditInfo:(MultiScenarioInputValue*)boolVal withLabel:(NSString*)label
	andSubtitle:(NSString*)subTitle
{
	assert(boolVal != nil);
	assert([StringValidation nonEmptyString:label]);
	
	MultiScenarioBoolInputValueFieldInfo *boolFieldInfo =
		[[[MultiScenarioBoolInputValueFieldInfo alloc] 
			initWithDataModelController:self.formContext.dataModelController andFieldLabel:label 
			andFieldPlaceholder:@"n/a" andScenario:self.inputScenario 
		andInputVal:boolVal] autorelease];
	BoolFieldEditInfo *boolFieldEditInfo = 
		[[[BoolFieldEditInfo alloc] initWithFieldInfo:boolFieldInfo andSubtitle:subTitle] autorelease];
		
	return boolFieldEditInfo;
}

-(BoolFieldEditInfo *)populateMultiScenBoolField:(MultiScenarioInputValue*)boolVal withLabel:(NSString*)label
	andSubtitle:(NSString*)subTitle // subTitle is optional and can be nil for no subtitle
{
	BoolFieldEditInfo *boolFieldEditInfo = [self multiScenBoolFieldEditInfo:boolVal
			withLabel:label andSubtitle:subTitle];
		
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:boolFieldEditInfo];
	
	return boolFieldEditInfo;
}

-(BoolFieldEditInfo *)populateMultiScenBoolField:(MultiScenarioInputValue*)boolVal withLabel:(NSString*)label
{
	return [self populateMultiScenBoolField:boolVal withLabel:label andSubtitle:nil];
}


-(BoolFieldShowHideCondition *)populateConditionalFieldVisibilityMultiScenBoolField:
		(MultiScenarioInputValue*)boolVal
		withLabel:(NSString*)label
{
	BoolFieldEditInfo *boolFieldEditInfo =
		[self populateMultiScenBoolField:boolVal withLabel:label andSubtitle:nil];

	BoolFieldShowHideCondition *showOrHideFieldsCondition =
		[[[BoolFieldShowHideCondition alloc] initWithFieldInfo:boolFieldEditInfo.fieldInfo] autorelease];
		
	[self.formInfo
		listenToFieldShowHideChangeTrigger:boolFieldEditInfo.boolCell.boolFieldChangedTrigger];
	
	return showOrHideFieldsCondition;
	
}

-(void)populateMultiScenBoolField:(MultiScenarioInputValue*)boolVal withLabel:(NSString*)label
	andShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{
	BoolFieldEditInfo *boolFieldEditInfo = [self multiScenBoolFieldEditInfo:boolVal
			withLabel:label andSubtitle:nil];
			
	assert(self.currentSection != nil);
			
	[self.currentSection addConditionallyShownFieldEditInfo:boolFieldEditInfo
		withShowHideCondition:showHideCondition];

}

-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt 
		andObjectForDelete:(NSManagedObject*)objForDelete
		andValidator:(NumberFieldValidator*)validator
{
	assert(inputVal != nil);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:prompt]);
	
	MultiScenarioFixedValueFieldInfo *fieldInfo =
		[[[MultiScenarioFixedValueFieldInfo alloc] 
			initWithDataModelController:self.formContext.dataModelController 
			andFieldLabel:label 
			andFieldPlaceholder:prompt
			andScenario:self.inputScenario  andInputVal:inputVal] autorelease];
   NumberFieldEditInfo *fieldEditInfo = 
		[[[NumberFieldEditInfo alloc] initWithFieldInfo:fieldInfo
			andNumberFormatter:[NumberHelper theHelper].decimalFormatter
			andValidator:validator] autorelease];
	fieldEditInfo.objectForDelete = objForDelete;
	assert(self.currentSection != nil);
	
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:fieldEditInfo];

}

-(void)populateMultiScenFixedValField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt
	andValidator:(NumberFieldValidator*)validator
{
	[self populateMultiScenFixedValField:inputVal andValLabel:label
	 andPrompt:prompt andObjectForDelete:nil andValidator:validator];
}


-(void)populateMultiScenPercentField:(MultiScenarioInputValue*)inputVal
	andValLabel:(NSString*)label andPrompt:(NSString*)prompt andAllowGreaterThan100Percent:(BOOL)allowGreaterThan100
{
	assert(inputVal != nil);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:prompt]);
	
	MultiScenarioFixedValueFieldInfo *fieldInfo =
		[[[MultiScenarioFixedValueFieldInfo alloc] 
			initWithDataModelController:self.formContext.dataModelController 
			andFieldLabel:label 
			andFieldPlaceholder:prompt
			andScenario:self.inputScenario  andInputVal:inputVal] autorelease];
			
	NumberFieldValidator *percentValidator;		
	if(allowGreaterThan100)
	{
		percentValidator = [[[PercentFieldValidator alloc] init] autorelease];
	}
	else
	{
		percentValidator = [[[UpTo100PercentFieldValidator alloc] init] autorelease];
	}
			
   NumberFieldEditInfo *fieldEditInfo = 
		[[[NumberFieldEditInfo alloc] initWithFieldInfo:fieldInfo
			andNumberFormatter:[NumberHelper theHelper].percentFormatter
			andValidator:percentValidator] autorelease];
	
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:fieldEditInfo];

}


-(void)populateCurrencyField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
	andSubtitle:(NSString*)subTitle
{
	assert(parentObj != nil);
	assert([StringValidation nonEmptyString:valKey]);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:placeholder]);
	
	
	ManagedObjectFieldInfo *fieldInfo = [[[ManagedObjectFieldInfo alloc]
              initWithManagedObject:parentObj andFieldKey:valKey andFieldLabel:label
										 andFieldPlaceholder:placeholder] autorelease];
    NumberFieldEditInfo *currencyFieldEditInfo = [[[NumberFieldEditInfo alloc]
		initWithFieldInfo:fieldInfo
		andNumberFormatter:[NumberHelper theHelper].currencyFormatter
		andValidator:[[[PositiveAmountValidator alloc] init] autorelease]
		andSubtitle:subTitle] autorelease];

	
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:currencyFieldEditInfo];
}


-(void)populateCurrencyField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
{
	[self populateCurrencyField:parentObj andValKey:valKey andLabel:label andPlaceholder:placeholder andSubtitle:nil];
}

-(void)populatePercentField:(NSManagedObject*)parentObj andValKey:(NSString*)valKey
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
{
	assert(parentObj != nil);
	assert([StringValidation nonEmptyString:valKey]);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:placeholder]);
	
	NumberFieldEditInfo *percentFieldEditInfo = 
			[NumberFieldEditInfo createForObject:parentObj 
				andKey:valKey andLabel:label andPlaceholder:placeholder
			andNumberFormatter:[NumberHelper theHelper].percentFormatter
			andValidator:[[[PercentFieldValidator alloc] init] autorelease]];

	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:percentFieldEditInfo];
}


-(DateSensitiveValueFieldEditInfo*)multiScenAmountFieldEditInfoForAmount:(MultiScenarioAmount*)theAmount 
	withValueTitle:(NSString*)valueTitle andValueName:(NSString*)valueName
{
	assert(theAmount != nil);
	
	
	VariableValueRuntimeInfo *amountRuntimeInfo = [VariableValueRuntimeInfo 
		createForDataModelController:self.formContext.dataModelController 
		andMultiScenarioAmount:theAmount withValueTitle:valueTitle andValueName:valueName];
		
	DateSensitiveValueFieldEditInfo *amountFieldEditInfo = [DateSensitiveValueFieldEditInfo 
	  createForDataModelController:self.formContext.dataModelController
	  andScenario:self.inputScenario andMultiScenFixedVal:theAmount.amount
		andLabel:LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_VALUE_TITLE")
	  andValRuntimeInfo:amountRuntimeInfo
	  andDefaultFixedVal:theAmount.defaultFixedAmount
	  andForNewVal:self.isForNewObject];

	return amountFieldEditInfo;
}

-(void)populateMultiScenarioAmount:(MultiScenarioAmount*)theAmount 
	withValueTitle:(NSString*)valueTitle andValueName:(NSString*)valueName
{
	DateSensitiveValueFieldEditInfo *amountFieldEditInfo =
		[self multiScenAmountFieldEditInfoForAmount:theAmount
		withValueTitle:valueTitle andValueName:valueName];
	
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:amountFieldEditInfo];
}

-(void)populateMultiScenarioAmount:(MultiScenarioAmount*)theAmount 
	withValueTitle:(NSString*)valueTitle andValueName:(NSString*)valueName
	withShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{
	DateSensitiveValueFieldEditInfo *amountFieldEditInfo =
		[self multiScenAmountFieldEditInfoForAmount:theAmount
		withValueTitle:valueTitle andValueName:valueName];
	assert(self.currentSection != nil);
	[self.currentSection addConditionallyShownFieldEditInfo:amountFieldEditInfo
		withShowHideCondition:showHideCondition];
}

-(void)populateMultiScenarioLoanOrigAmount:(MultiScenarioAmount*)theAmount
	withValueTitle:(NSString*)valueTitle andValueName:(NSString*)valueName
{
	VariableValueRuntimeInfo *amountRuntimeInfo = [VariableValueRuntimeInfo 
		createForDataModelController:self.formContext.dataModelController 
		andMultiScenarioAmount:theAmount withValueTitle:valueTitle andValueName:valueName
		andTableSubtitle:LOCALIZED_STR(@"INPUT_LOAN_COST_AMOUNT_TABLE_SUBTITLE")];
		
	DateSensitiveValueFieldEditInfo *amountFieldEditInfo = [DateSensitiveValueFieldEditInfo 
	  createForDataModelController:self.formContext.dataModelController
	  andScenario:self.inputScenario andMultiScenFixedVal:theAmount.amount
		andLabel:LOCALIZED_STR(@"INPUT_CASH_FLOW_AMOUNT_VALUE_TITLE")
	  andValRuntimeInfo:amountRuntimeInfo
	  andDefaultFixedVal:theAmount.defaultFixedAmount
	  andForNewVal:self.isForNewObject];

	
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:amountFieldEditInfo];
}

-(VariableValueRuntimeInfo*)inflationRateRuntimInfoWithValueLabel:(NSString*)valueLabel
	andValueName:(NSString*)valueName
{
	assert([StringValidation nonEmptyString:valueLabel]);

	SharedEntityVariableValueListMgr *sharedInflationRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] 
		initWithDataModelController:self.formContext.dataModelController
		andEntity:INFLATION_RATE_ENTITY_NAME] autorelease];
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"INPUT_INFLATION_RATE__TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE")];
	
	VariableValueRuntimeInfo *grRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueValidator: [[[GrowthRateFieldValidator alloc] init] autorelease]
		andValueTitle:@"INPUT_INFLATION_RATE_VALUE_TITLE"
		andInlineValueTitleKey:@"INPUT_INFLATION_RATE_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"INPUT_INFLATION_RATE_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"INPUT_INFLATION_RATE_PERIOD") 
		andListMgr:sharedInflationRatesMgr
		andSingleValHelpInfoFile:@"fixedInflation"
		andVariableValHelpInfoFile:@"variableInflation"
		andValuePromptKey:@"INPUT_INFLATION_RATE_VALUE_PROMPT"
		andValueTypeTitle:valueLabel
		andValueName:valueName
		andTableSubtitle:tableSubtitle] autorelease];
		
	return grRuntimeInfo;

}

-(DateSensitiveValueFieldEditInfo*)multiScenarioGrowthRateFieldInfo:(MultiScenarioGrowthRate*)growthRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{

	assert([StringValidation nonEmptyString:valueLabel]);
	assert(growthRate != nil);
		
	VariableValueRuntimeInfo *grRuntimeInfo =
		[self inflationRateRuntimInfoWithValueLabel:valueLabel
		andValueName:valueName];
		
	DateSensitiveValueFieldEditInfo *fieldEditInfo = [DateSensitiveValueFieldEditInfo
         createForDataModelController:self.formContext.dataModelController
			andScenario:self.inputScenario andMultiScenFixedVal:growthRate.growthRate
			andLabel:LOCALIZED_STR(@"INPUT_INFLATION_RATE_VALUE_TITLE")  
		 andValRuntimeInfo:grRuntimeInfo 
		 andDefaultFixedVal:growthRate.defaultFixedGrowthRate
		 andForNewVal:self.isForNewObject];

	return fieldEditInfo;
}


-(void)populateMultiScenarioGrowthRate:(MultiScenarioGrowthRate*)growthRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{
	DateSensitiveValueFieldEditInfo *fieldEditInfo =
		[self multiScenarioGrowthRateFieldInfo:growthRate withLabel:valueLabel andValueName:valueName];

	assert(self.currentSection != nil);
	
	[self.currentSection addFieldEditInfo:fieldEditInfo];
}

-(void)populateMultiScenarioGrowthRate:(MultiScenarioGrowthRate*)growthRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName withShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{
	DateSensitiveValueFieldEditInfo *fieldEditInfo =
		[self multiScenarioGrowthRateFieldInfo:growthRate withLabel:valueLabel andValueName:valueName];

	assert(self.currentSection != nil);
	
	[self.currentSection addConditionallyShownFieldEditInfo:fieldEditInfo
		withShowHideCondition:showHideCondition];
}


-(void)populateSingleScenarioVariableValue:(VariableValue*)growthRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{
	assert(growthRate != nil);
		
	VariableValueRuntimeInfo *grRuntimeInfo = [self inflationRateRuntimInfoWithValueLabel:valueLabel 
		andValueName:valueName];
		
	VariableValueFieldEditInfo *vvFieldInfo = [[[VariableValueFieldEditInfo alloc]
		initWithVariableValue:growthRate
				andVarValRuntimeInfo:grRuntimeInfo] autorelease];
        // Create the row information for the given milestone date.
	[self.currentSection addFieldEditInfo:vvFieldInfo];

		

}


- (void)populateMultiScenarioInvestmentReturnRate:(MultiScenarioGrowthRate*)roiRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{
	assert([StringValidation nonEmptyString:valueLabel]);
	assert(roiRate != nil);


	SharedEntityVariableValueListMgr *sharedROIMgr = 
	[[[SharedEntityVariableValueListMgr alloc] 
		initWithDataModelController:self.formContext.dataModelController 
		andEntity:INVESTMENT_RETURN_RATE_ENTITY_NAME] autorelease];
	
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"SHARED_ROI_TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"SHARED_ROI_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"SHARED_ROI_INLINE_VALUE_TITLE")];

	
	VariableValueRuntimeInfo *roiRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueValidator:[[[GrowthRateFieldValidator alloc] init] autorelease]
		andValueTitle:@"SHARED_ROI_VALUE_TITLE"
		andInlineValueTitleKey:@"SHARED_ROI_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"SHARED_ROI_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"SHARED_ROI_PERIOD") 
		andListMgr:sharedROIMgr
		andSingleValHelpInfoFile:@"fixedReturn"
		andVariableValHelpInfoFile:@"variableReturn"
		andValuePromptKey:@"SHARED_ROI_VALUE_PROMPT"
		andValueTypeTitle:valueLabel
		andValueName:valueName
		andTableSubtitle:tableSubtitle] autorelease];
		
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForDataModelController:self.formContext.dataModelController
			andScenario:self.inputScenario andMultiScenFixedVal:roiRate.growthRate 
			andLabel:LOCALIZED_STR(@"SHARED_ROI_VALUE_TITLE") 
		 andValRuntimeInfo:roiRuntimeInfo 
		 andDefaultFixedVal:roiRate.defaultFixedGrowthRate
		 andForNewVal:self.isForNewObject]];


}

-(DateSensitiveValueFieldEditInfo *)multiScenarioDividendReturnRate:(MultiScenarioGrowthRate*)dividendRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{
	assert([StringValidation nonEmptyString:valueLabel]);
	assert(dividendRate != nil);

	SharedEntityVariableValueListMgr *sharedDividendMgr =
	[[[SharedEntityVariableValueListMgr alloc] 
		initWithDataModelController:self.formContext.dataModelController 
		andEntity:DIVIDEND_RATE_ENTITY_NAME] autorelease];
	
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"SHARED_DIVIDEND_TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"SHARED_DIVIDEND_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"SHARED_DIVIDEND_INLINE_VALUE_TITLE")];
	
	VariableValueRuntimeInfo *dividendRateRuntimeInfo = [[[VariableValueRuntimeInfo alloc]
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueValidator:[[[GrowthRateFieldValidator alloc] init] autorelease]
		andValueTitle:@"SHARED_DIVIDEND_VALUE_TITLE"
		andInlineValueTitleKey:@"SHARED_DIVIDEND_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"SHARED_DIVIDEND_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"SHARED_DIVIDEND_PERIOD") 
		andListMgr:sharedDividendMgr
		andSingleValHelpInfoFile:@"fixedDividend"
		andVariableValHelpInfoFile:@"variableDividend"
		andValuePromptKey:@"SHARED_DIVIDEND_VALUE_PROMPT"
		andValueTypeTitle:valueLabel
		andValueName:valueName
		andTableSubtitle:tableSubtitle] autorelease];
		
	DateSensitiveValueFieldEditInfo *fieldEditInfo = [DateSensitiveValueFieldEditInfo
         createForDataModelController:self.formContext.dataModelController
			andScenario:self.inputScenario andMultiScenFixedVal:dividendRate.growthRate 
			andLabel:LOCALIZED_STR(@"SHARED_DIVIDEND_VALUE_TITLE") 
		 andValRuntimeInfo:dividendRateRuntimeInfo 
		 andDefaultFixedVal:dividendRate.defaultFixedGrowthRate
		 andForNewVal:self.isForNewObject];
		
	return fieldEditInfo;

}


- (void)populateMultiScenarioDividendReturnRate:(MultiScenarioGrowthRate*)dividendRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{
	DateSensitiveValueFieldEditInfo *fieldEditInfo =
		[self multiScenarioDividendReturnRate:dividendRate
		withLabel:valueLabel andValueName:valueName];
	
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:fieldEditInfo];
}

- (void)populateMultiScenarioDividendReturnRate:(MultiScenarioGrowthRate*)dividendRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName andShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{
	DateSensitiveValueFieldEditInfo *fieldEditInfo =
		[self multiScenarioDividendReturnRate:dividendRate
		withLabel:valueLabel andValueName:valueName];
	
	assert(self.currentSection != nil);
	[self.currentSection addConditionallyShownFieldEditInfo:fieldEditInfo withShowHideCondition:showHideCondition];
}


- (void)populateMultiScenarioApprecRate:(MultiScenarioGrowthRate*)apprecRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{
	assert([StringValidation nonEmptyString:valueLabel]);
	assert(apprecRate != nil);

	
	VariableValueRuntimeInfo *apprecRateRuntimeInfo = [VariableValueRuntimeInfo createForAssetAppreciationRateWithDataModelController:self.formContext.dataModelController
		withLabel:valueLabel andValueName:valueName];
	
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
         createForDataModelController:self.formContext.dataModelController
		 andScenario:self.inputScenario andMultiScenFixedVal:apprecRate.growthRate 
			andLabel:LOCALIZED_STR(@"SHARED_APPREC_RATE_VALUE_TITLE") 
		 andValRuntimeInfo:apprecRateRuntimeInfo 
		 andDefaultFixedVal:apprecRate.defaultFixedGrowthRate
		 andForNewVal:self.isForNewObject]];


}



- (void)populateMultiScenarioInterestRate:(MultiScenarioGrowthRate*)intRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{
	assert([StringValidation nonEmptyString:valueLabel]);
	assert(intRate != nil);


	SharedEntityVariableValueListMgr *sharedInterestRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] 
		initWithDataModelController:self.formContext.dataModelController 
		andEntity:INTEREST_RATE_ENTITY_NAME] autorelease];
	
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"SHARED_INTEREST_RATE_TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"SHARED_INTEREST_RATE_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"SHARED_INTEREST_RATE_INLINE_VALUE_TITLE")];

	
	VariableValueRuntimeInfo *interestRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueValidator:[[[PercentFieldValidator alloc] init] autorelease]
		andValueTitle:@"SHARED_INTEREST_RATE_VALUE_TITLE"
		andInlineValueTitleKey:@"SHARED_INTEREST_RATE_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"SHARED_INTEREST_RATE_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"SHARED_INTEREST_RATE_PERIOD") 
		andListMgr:sharedInterestRatesMgr
		andSingleValHelpInfoFile:@"fixedInterest"
		andVariableValHelpInfoFile:@"variableInterest"
		andValuePromptKey:@"SHARED_INTEREST_RATE_VALUE_PROMPT"
		andValueTypeTitle:valueLabel
		andValueName:valueName
		andTableSubtitle:tableSubtitle] autorelease];
		
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
			createForDataModelController:self.formContext.dataModelController 
			andScenario:self.inputScenario andMultiScenFixedVal:intRate.growthRate
			andLabel:LOCALIZED_STR(@"SHARED_INTEREST_RATE_VALUE_TITLE") 
		 andValRuntimeInfo:interestRuntimeInfo 
		 andDefaultFixedVal:intRate.defaultFixedGrowthRate
		 andForNewVal:self.isForNewObject]];

}

- (void)populateMultiScenarioTaxRate:(MultiScenarioGrowthRate*)taxRate
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{
	assert([StringValidation nonEmptyString:valueLabel]);
	assert(taxRate != nil);

	SharedEntityVariableValueListMgr *sharedInterestRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] 
		initWithDataModelController:self.formContext.dataModelController 
		andEntity:TAX_RATE_ENTITY_NAME] autorelease];
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"SHARED_TAX_RATE_TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"SHARED_TAX_RATE_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"SHARED_TAX_RATE_INLINE_VALUE_TITLE")];

	
	VariableValueRuntimeInfo *taxRateRuntimeInfo = [[[VariableValueRuntimeInfo alloc]
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
        andValueValidator:[[[UpTo100PercentFieldValidator alloc] init] autorelease]
		andValueTitle:@"SHARED_TAX_RATE_VALUE_TITLE"
		andInlineValueTitleKey:@"SHARED_TAX_RATE_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"SHARED_TAX_RATE_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"SHARED_TAX_RATE_PERIOD") 
		andListMgr:sharedInterestRatesMgr
		andSingleValHelpInfoFile:@"fixedTaxRate"
		andVariableValHelpInfoFile:@"variableTaxRate"
		andValuePromptKey:@"SHARED_TAX_RATE_VALUE_PROMPT"
		andValueTypeTitle:valueLabel
		andValueName:valueName
		andTableSubtitle:tableSubtitle] autorelease];
		
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:
        [DateSensitiveValueFieldEditInfo 
			createForDataModelController:self.formContext.dataModelController 
			andScenario:self.inputScenario andMultiScenFixedVal:taxRate.growthRate
			andLabel:LOCALIZED_STR(@"SHARED_TAX_RATE_VALUE_TITLE") 
		 andValRuntimeInfo:taxRateRuntimeInfo 
		 andDefaultFixedVal:taxRate.defaultFixedGrowthRate
		 andForNewVal:self.isForNewObject]];

}


-(DateSensitiveValueFieldEditInfo*)loanDownPmtPercentFieldEditInfo:(LoanInput*)loan
	withValueLabel:(NSString*)valueLabel
	andValueName:(NSString*)valueName
{
	SharedEntityVariableValueListMgr *sharedDownPmtMgr = 
	[[[SharedEntityVariableValueListMgr alloc] 
		initWithDataModelController:self.formContext.dataModelController 
		andEntity:LOAN_DOWN_PMT_PERCENT_ENTITY_NAME] autorelease];

	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"SHARED_LOAN_DOWN_PMT_TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"SHARED_LOAN_DOWN_PMT_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"SHARED_LOAN_DOWN_PMT_INLINE_VALUE_TITLE")];


	VariableValueRuntimeInfo *downPmtVarValRuntimeInfo = [[[VariableValueRuntimeInfo alloc] 
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueValidator:[[[UpTo100PercentFieldValidator alloc] init] autorelease]
		andValueTitle:@"SHARED_LOAN_DOWN_PMT_VALUE_TITLE"
		andInlineValueTitleKey:@"SHARED_LOAN_DOWN_PMT_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"SHARED_LOAN_DOWN_PMT_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"SHARED_LOAN_DOWN_PMT_PERIOD") 
		andListMgr:sharedDownPmtMgr
		andSingleValHelpInfoFile:@"fixedLoanDownPmt"
		andVariableValHelpInfoFile:@"variableLoanDownPmt"
		andValuePromptKey:@"SHARED_LOAN_DOWN_PMT_VALUE_PROMPT"
		andValueTypeTitle:valueLabel
		andValueName:valueName
		andTableSubtitle:tableSubtitle] autorelease];
	
	DateSensitiveValueFieldEditInfo *fieldEditInfo = [DateSensitiveValueFieldEditInfo
	  createForDataModelController:self.formContext.dataModelController
	  andScenario:self.inputScenario andMultiScenFixedVal:loan.multiScenarioDownPmtPercent
	  andLabel:LOCALIZED_STR(@"INPUT_LOAN_DOWN_PMT_PERCENT_FIELD_LABEL") 
	  andValRuntimeInfo:downPmtVarValRuntimeInfo
	  andDefaultFixedVal:loan.multiScenarioDownPmtPercentFixed
		 andForNewVal:self.isForNewObject];
		
    return fieldEditInfo;

}

-(void)populateLoanDownPmtPercent:(LoanInput*)loan withValueLabel:(NSString*)valueLabel
	andValueName:(NSString*)valueName
{
	DateSensitiveValueFieldEditInfo *fieldEditInfo =
		[self loanDownPmtPercentFieldEditInfo:loan withValueLabel:valueLabel andValueName:valueName];
		
    [self.currentSection addFieldEditInfo:fieldEditInfo];
}

-(void)populateLoanDownPmtPercent:(LoanInput*)loan withValueLabel:(NSString*)valueLabel
	andValueName:(NSString*)valueName andShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{
	DateSensitiveValueFieldEditInfo *fieldEditInfo =
		[self loanDownPmtPercentFieldEditInfo:loan withValueLabel:valueLabel andValueName:valueName];
	[self.currentSection addConditionallyShownFieldEditInfo:fieldEditInfo withShowHideCondition:showHideCondition];
}

-(DateSensitiveValueFieldEditInfo*)multiScenarioDividendReinvestPercent:(MultiScenarioPercent*)multiScenPercent
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{
	assert([StringValidation nonEmptyString:valueLabel]);
	assert(multiScenPercent != nil);


	SharedEntityVariableValueListMgr *sharedInterestRatesMgr = 
	[[[SharedEntityVariableValueListMgr alloc] 
		initWithDataModelController:self.formContext.dataModelController 
		andEntity:DIVIDEND_REINVEST_PERCENT_ENTITY_NAME] autorelease];
	
	
	NSString *tableSubtitle = [NSString 
			stringWithFormat:LOCALIZED_STR(@"SHARED_INTEREST_RATE_TABLE_SUBTITLE_FORMAT"),
			LOCALIZED_STR(@"SHARED_DIV_REINVEST_INLINE_VALUE_TITLE"),
			LOCALIZED_STR(@"SHARED_DIV_REINVEST_INLINE_VALUE_TITLE")];

	VariableValueRuntimeInfo *divRuntimeInfo = [[[VariableValueRuntimeInfo alloc]
		initWithFormatter:[NumberHelper theHelper].percentFormatter 
		andValueValidator:[[[UpTo100PercentFieldValidator alloc] init] autorelease]
		andValueTitle:@"SHARED_DIV_REINVEST_VALUE_TITLE"
		andInlineValueTitleKey:@"SHARED_DIV_REINVEST_INLINE_VALUE_TITLE"
		andValueVerb:LOCALIZED_STR(@"SHARED_DIV_REINVEST_ACTION_VERB")
		andPeriodDesc:LOCALIZED_STR(@"SHARED_DIV_REINVEST_PERIOD") 
		andListMgr:sharedInterestRatesMgr
		andSingleValHelpInfoFile:@"fixedDivReinvestPercent"
		andVariableValHelpInfoFile:@"variableDivReinvestPercent"
		andValuePromptKey:@"SHARED_DIV_REINVEST_VALUE_PROMPT"
		andValueTypeTitle:valueLabel
		andValueName:valueName
		andTableSubtitle:tableSubtitle] autorelease];
		
	DateSensitiveValueFieldEditInfo *fieldEditInfo = [DateSensitiveValueFieldEditInfo
			createForDataModelController:self.formContext.dataModelController 
			andScenario:self.inputScenario andMultiScenFixedVal:multiScenPercent.percent
			andLabel:LOCALIZED_STR(@"SHARED_DIV_REINVEST_VALUE_TITLE") 
		 andValRuntimeInfo:divRuntimeInfo 
		 andDefaultFixedVal:multiScenPercent.defaultFixedPercent
		 andForNewVal:self.isForNewObject];
		
	return fieldEditInfo;
}


- (void)populateMultiScenarioDividendReinvestPercent:(MultiScenarioPercent*)multiScenPercent
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName
{
	DateSensitiveValueFieldEditInfo *fieldEditInfo =
		[self multiScenarioDividendReinvestPercent:multiScenPercent withLabel:valueLabel andValueName:valueName];
		
	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:fieldEditInfo];

}

- (void)populateMultiScenarioDividendReinvestPercent:(MultiScenarioPercent*)multiScenPercent
	withLabel:(NSString*)valueLabel 
	andValueName:(NSString*)valueName andShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{
	DateSensitiveValueFieldEditInfo *fieldEditInfo =
		[self multiScenarioDividendReinvestPercent:multiScenPercent withLabel:valueLabel andValueName:valueName];
		
	assert(self.currentSection != nil);
	[self.currentSection addConditionallyShownFieldEditInfo:fieldEditInfo withShowHideCondition:showHideCondition];

}


-(RepeatFrequencyFieldEditInfo*)populateRepeatFrequency:(MultiScenarioInputValue*)repeatFreq
	andLabel:(NSString*)label
{
	assert(repeatFreq != nil);
	assert([StringValidation nonEmptyString:label]);
	
    RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = [RepeatFrequencyFieldEditInfo 
		createForScenario:self.inputScenario andRepeatFreq:repeatFreq andLabel:label];
		
	assert(self.currentSection != nil);
    [self.currentSection addFieldEditInfo:repeatFrequencyInfo];

	return repeatFrequencyInfo;
}

-(RepeatFrequencyFieldEditInfo*)populateRepeatFrequency:(MultiScenarioInputValue*)repeatFreq
	andLabel:(NSString*)label andShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{
	assert(repeatFreq != nil);
	assert([StringValidation nonEmptyString:label]);
	
    RepeatFrequencyFieldEditInfo *repeatFrequencyInfo = [RepeatFrequencyFieldEditInfo 
		createForScenario:self.inputScenario andRepeatFreq:repeatFreq andLabel:label];
		
	assert(self.currentSection != nil);
	[self.currentSection addConditionallyShownFieldEditInfo:repeatFrequencyInfo withShowHideCondition:showHideCondition];
	return repeatFrequencyInfo;
}


-(void)populateMultiScenarioDuration:(MultiScenarioInputValue*)duration 
	andLabel:(NSString*)label andPlaceholder:(NSString*)placeholder
{
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:placeholder]);
	assert(duration != nil);

	MultiScenarioFixedValueFieldInfo *durationFieldInfo =
		[[[MultiScenarioFixedValueFieldInfo alloc] 
			initWithDataModelController:self.formContext.dataModelController 
			andFieldLabel:label
			andFieldPlaceholder:placeholder
			andScenario:self.inputScenario 
		andInputVal:duration] autorelease];
	DurationFieldEditInfo *durationFieldEditInfo = 
		[[[DurationFieldEditInfo alloc] initWithFieldInfo:durationFieldInfo] autorelease];

	assert(self.currentSection != nil);
	[self.currentSection addFieldEditInfo:durationFieldEditInfo];
}

-(SimDateFieldEditInfo *)multiScenSimDateFieldEditInfo:(MultiScenarioSimDate*)multiScenSimDate
	andLabel:(NSString*)label andTitle:(NSString*)title
	andTableHeader:(NSString*)tableHeader andTableSubHeader:(NSString*)tableSubHeader
{
	assert(multiScenSimDate != nil);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:title]);
	assert([StringValidation nonEmptyString:tableHeader]);
	assert([StringValidation nonEmptyString:tableSubHeader]);
	
	BOOL supportEndDates = FALSE;

 	SimDateRuntimeInfo *simDateInfo = 
		[[[SimDateRuntimeInfo alloc] initWithTableTitle:title 
			andHeader:tableHeader andSubHeader:tableSubHeader 
			andSupportsNeverEndDate:supportEndDates] autorelease];
			
	SimDateFieldEditInfo *simDateFieldEditInfo = 
		[SimDateFieldEditInfo createForDataModelController:self.formContext.dataModelController 
			andMultiScenarioVal:self.inputScenario 
			andSimDate:multiScenSimDate.simDate 
			andLabel:label 
			andDefaultValue:multiScenSimDate.defaultFixedSimDate 
			andVarDateRuntimeInfo:simDateInfo andShowEndDates:supportEndDates
			andDefaultRelEndDate:nil];
			
	return simDateFieldEditInfo;
}

-(void)populateMultiScenSimDate:(MultiScenarioSimDate*)multiScenSimDate 
	andLabel:(NSString*)label andTitle:(NSString*)title
	andTableHeader:(NSString*)tableHeader andTableSubHeader:(NSString*)tableSubHeader
{			
	SimDateFieldEditInfo *simDateFieldEditInfo = [self multiScenSimDateFieldEditInfo:multiScenSimDate andLabel:label andTitle:title andTableHeader:tableHeader andTableSubHeader:tableSubHeader];
		
    [self.currentSection addFieldEditInfo:simDateFieldEditInfo];

}

-(void)populateMultiScenSimDate:(MultiScenarioSimDate*)multiScenSimDate 
	andLabel:(NSString*)label andTitle:(NSString*)title
	andTableHeader:(NSString*)tableHeader andTableSubHeader:(NSString*)tableSubHeader
	andShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{
	SimDateFieldEditInfo *simDateFieldEditInfo = [self multiScenSimDateFieldEditInfo:multiScenSimDate andLabel:label andTitle:title andTableHeader:tableHeader andTableSubHeader:tableSubHeader];

	[self.currentSection addConditionallyShownFieldEditInfo:simDateFieldEditInfo withShowHideCondition:showHideCondition];
}

-(SimDateFieldEditInfo*)multiScenSimEndDateFieldEditInfo:(MultiScenarioSimEndDate*)multiScenSimEndDate
	andLabel:(NSString*)label andTitle:(NSString*)title 
	andTableHeader:(NSString*)tableHeader andTableSubHeader:(NSString*)tableSubHeader
	andNeverEndFieldTitle:(NSString*)neverEndFieldTitle
	andNeverEndFieldSubtitle:(NSString*)neverEndFieldSubTitle
	andNeverEndSectionTitle:(NSString*)neverEndSectionTitle
	andNeverEndHelpInfo:(NSString*)neverEndHelpFile
	andRelEndDateSectionTitle:(NSString*)relEndDateSectionTitle
	andRelEndDateHelpFile:(NSString*)relEndDateHelpFile
	andRelEndDateFieldLabel:(NSString*)relEndDateFieldLabel
{
	assert(multiScenSimEndDate != nil);
	assert([StringValidation nonEmptyString:label]);
	assert([StringValidation nonEmptyString:title]);
	assert([StringValidation nonEmptyString:tableHeader]);
	assert([StringValidation nonEmptyString:tableSubHeader]);
	assert([StringValidation nonEmptyString:neverEndFieldTitle]);
	assert([StringValidation nonEmptyString:neverEndFieldSubTitle]);
	assert([StringValidation nonEmptyString:neverEndSectionTitle]);
	assert([StringValidation nonEmptyString:neverEndHelpFile]);
	assert([StringValidation nonEmptyString:relEndDateSectionTitle]);
	assert([StringValidation nonEmptyString:relEndDateHelpFile]);
	assert([StringValidation nonEmptyString:relEndDateFieldLabel]);
	
	BOOL doSupportNeverEndDates = TRUE;

 	SimDateRuntimeInfo *simDateInfo = 
		[[[SimDateRuntimeInfo alloc] initWithTableTitle:title 
			andHeader:tableHeader andSubHeader:tableSubHeader 
			andSupportsNeverEndDate:doSupportNeverEndDates] autorelease];
	simDateInfo.neverEndDateFieldSubtitle = neverEndFieldSubTitle;
	simDateInfo.neverEndDateFieldCaption = neverEndFieldTitle;
	simDateInfo.neverEndDateSectionTitle = neverEndSectionTitle;
	simDateInfo.neverEndDateHelpFile = neverEndHelpFile;
	simDateInfo.relEndDateSectionTitle = relEndDateSectionTitle;
	simDateInfo.relEndDateHelpFile = relEndDateHelpFile;
	simDateInfo.relEndDateFieldLabel = relEndDateFieldLabel;
			
			
	SimDateFieldEditInfo *simDateFieldEditInfo = 
		[SimDateFieldEditInfo createForDataModelController:self.formContext.dataModelController 
			andMultiScenarioVal:self.inputScenario 
			andSimDate:multiScenSimEndDate.simDate
			andLabel:label 
			andDefaultValue:multiScenSimEndDate.defaultFixedSimDate 
			andVarDateRuntimeInfo:simDateInfo andShowEndDates:doSupportNeverEndDates
			andDefaultRelEndDate:multiScenSimEndDate.defaultFixedRelativeEndDate];


	return simDateFieldEditInfo;
}

-(void)populateMultiScenSimEndDate:(MultiScenarioSimEndDate*)multiScenSimEndDate 
	andLabel:(NSString*)label andTitle:(NSString*)title 
	andTableHeader:(NSString*)tableHeader andTableSubHeader:(NSString*)tableSubHeader
	andNeverEndFieldTitle:(NSString*)neverEndFieldTitle
	andNeverEndFieldSubtitle:(NSString*)neverEndFieldSubTitle
	andNeverEndSectionTitle:(NSString*)neverEndSectionTitle
	andNeverEndHelpInfo:(NSString*)neverEndHelpFile
	andRelEndDateSectionTitle:(NSString*)relEndDateSectionTitle
	andRelEndDateHelpFile:(NSString*)relEndDateHelpFile
	andRelEndDateFieldLabel:(NSString*)relEndDateFieldLabel
{			
			
	SimDateFieldEditInfo *simDateFieldEditInfo = [self multiScenSimEndDateFieldEditInfo:multiScenSimEndDate 
		andLabel:label andTitle:title 
		andTableHeader:tableHeader andTableSubHeader:tableSubHeader
		andNeverEndFieldTitle:neverEndFieldTitle
		andNeverEndFieldSubtitle:neverEndFieldSubTitle
		andNeverEndSectionTitle:neverEndSectionTitle
		andNeverEndHelpInfo:neverEndHelpFile
		andRelEndDateSectionTitle:relEndDateSectionTitle
		andRelEndDateHelpFile:relEndDateHelpFile
		andRelEndDateFieldLabel:relEndDateFieldLabel];

    [self.currentSection addFieldEditInfo:simDateFieldEditInfo];

}

-(void)populateMultiScenSimEndDate:(MultiScenarioSimEndDate*)multiScenSimEndDate 
	andLabel:(NSString*)label andTitle:(NSString*)title 
	andTableHeader:(NSString*)tableHeader andTableSubHeader:(NSString*)tableSubHeader
	andNeverEndFieldTitle:(NSString*)neverEndFieldTitle
	andNeverEndFieldSubtitle:(NSString*)neverEndFieldSubTitle
	andNeverEndSectionTitle:(NSString*)neverEndSectionTitle
	andNeverEndHelpInfo:(NSString*)neverEndHelpFile
	andRelEndDateSectionTitle:(NSString*)relEndDateSectionTitle
	andRelEndDateHelpFile:(NSString*)relEndDateHelpFile
	andRelEndDateFieldLabel:(NSString*)relEndDateFieldLabel
	andShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{			
			
	SimDateFieldEditInfo *simDateFieldEditInfo = [self multiScenSimEndDateFieldEditInfo:multiScenSimEndDate 
		andLabel:label andTitle:title 
		andTableHeader:tableHeader andTableSubHeader:tableSubHeader
		andNeverEndFieldTitle:neverEndFieldTitle
		andNeverEndFieldSubtitle:neverEndFieldSubTitle
		andNeverEndSectionTitle:neverEndSectionTitle
		andNeverEndHelpInfo:neverEndHelpFile
		andRelEndDateSectionTitle:relEndDateSectionTitle
		andRelEndDateHelpFile:relEndDateHelpFile
		andRelEndDateFieldLabel:relEndDateFieldLabel];

    [self.currentSection addConditionallyShownFieldEditInfo:simDateFieldEditInfo
		withShowHideCondition:showHideCondition];

}

-(SimDateFieldEditInfo*)loanDeferSimDateFieldEditInfo:(LoanInput*)loan withFieldLabel:(NSString*)fieldLabel
{
	SimDateFieldEditInfo *fieldEditInfo =
		[self multiScenSimEndDateFieldEditInfo:loan.deferredPaymentDate
		andLabel:fieldLabel
		andTitle:LOCALIZED_STR(@"INPUT_LOAN_DEFER_PAYMENT_TITLE")
			andTableHeader:LOCALIZED_STR(@"INPUT_LOAN_DEFER_PAYMENT_TABLE_TITLE")
			andTableSubHeader:[NSString stringWithFormat:
				LOCALIZED_STR(@"INPUT_LOAN_DEFER_PAYMENT_TABLE_SUBTITLE_FORMAT"),loan.name]
				andNeverEndFieldTitle:LOCALIZED_STR(@"INPUT_LOAN_DEFER_FOREVER_PAYMENT_FIELD_TITLE") 
				andNeverEndFieldSubtitle:LOCALIZED_STR(@"INPUT_LOAN_DEFER_FOREVER_PAYMENT_FIELD_SUBTITLE")
				andNeverEndSectionTitle:LOCALIZED_STR(@"INPUT_LOAN_DEFER_FOREVER_PAYMENT_SECTION_TITLE") 
				andNeverEndHelpInfo:@"neverEndDateDeferPmt"
				andRelEndDateSectionTitle:LOCALIZED_STR(@"INPUT_LOAN_DEFER_PAYMENT_REL_END_DATE_SECTION_TITLE")
				andRelEndDateHelpFile:@"relEndDateDeferPmt"
				andRelEndDateFieldLabel:LOCALIZED_STR(@"INPUT_LOAN_DEFER_PAYMENT_REL_END_DATE_FIELD_LABEL")];
	return fieldEditInfo;
}


-(void)populateLoanDeferPaymentDate:(LoanInput*)loan withFieldLabel:(NSString*)fieldLabel
{
	SimDateFieldEditInfo *fieldEditInfo = [self loanDeferSimDateFieldEditInfo:loan withFieldLabel:fieldLabel];
	
	[self.currentSection addFieldEditInfo:fieldEditInfo];
}

-(void)populateLoanDeferPaymentDate:(LoanInput*)loan withFieldLabel:(NSString*)fieldLabel
	withShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{
	SimDateFieldEditInfo *fieldEditInfo = [self loanDeferSimDateFieldEditInfo:loan withFieldLabel:fieldLabel];
	
	[self.currentSection addConditionallyShownFieldEditInfo:fieldEditInfo
		withShowHideCondition:showHideCondition];
}

-(void)populateItemizedTaxForTaxAmtsInfo:(ItemizedTaxAmtsInfo*)itemizedTaxAmtsInfo
	andTaxAmt:(ItemizedTaxAmt*)itemizedTaxAmt
	andTaxAmtCreator:(id<ItemizedTaxAmtCreator>)taxAmtCreator
{

	assert(itemizedTaxAmtsInfo != nil);
	assert(taxAmtCreator != nil);
	
	ItemizedTaxAmtFieldEditInfo *incomeFieldEditInfo = 
			[[[ItemizedTaxAmtFieldEditInfo alloc] 
				initWithDataModelController:self.formContext.dataModelController 
						andItemizedTaxAmts:itemizedTaxAmtsInfo.itemizedTaxAmts 
				andItemizedTaxAmtCreator:taxAmtCreator
				andItemizedTaxAmt:itemizedTaxAmt
				andItemizedTaxAmtsInfo:itemizedTaxAmtsInfo 
				andIsForNewObject:self.isForNewObject] autorelease];
	[self.currentSection addFieldEditInfo:incomeFieldEditInfo];

}

-(NSString*)itemizationTypeSummary:(NSMutableArray*)itemizationNameList andPrefix:(NSString*)itemTypePrefix
{
	if(itemizationNameList.count > 0)
	{
		NSString *formattedItemNameList = [itemizationNameList componentsJoinedByString:@","];
		return [NSString stringWithFormat:@"%@:%@",itemTypePrefix,formattedItemNameList];
	}
	return nil;
}

-(NSString*)itemizationSummaryForItemizedTaxAmtsInfo:(NSSet*)itemizedTaxAmts
{
	NSString *summary = nil;
	if(itemizedTaxAmts != nil)
	{
		NSMutableArray *sourceForTax = [[[NSMutableArray alloc] init] autorelease];
		NSMutableArray *creditForTax = [[[NSMutableArray alloc] init] autorelease];
		NSMutableArray *deductionForTax = [[[NSMutableArray alloc] init] autorelease];
		NSMutableArray *adjustmentForTax = [[[NSMutableArray alloc] init] autorelease];
		
		for(ItemizedTaxAmt *itemizedTaxAmt in itemizedTaxAmts)
		{
			if([itemizedTaxAmt.isEnabled boolValue])
			{
				ItemizedTaxAmts *taxAmts = itemizedTaxAmt.itemizedTaxAmts;
				assert(taxAmts != nil);
				
				if(taxAmts.taxItemizedIncomeSources != nil)
				{
					[sourceForTax addObject:taxAmts.taxItemizedIncomeSources.name];
				}
				
				if(taxAmts.taxItemizedCredits != nil)
				{
					[creditForTax addObject:taxAmts.taxItemizedCredits.name];
				}

				if(taxAmts.taxItemizedDeductions != nil)
				{
					[deductionForTax addObject:taxAmts.taxItemizedDeductions.name];
				}
				
				if(taxAmts.taxItemizedAdjustments != nil)
				{
					[adjustmentForTax addObject:taxAmts.taxItemizedAdjustments.name];
				}
				
			}
		}
		
		NSMutableArray *typeSummmaryList = [[[NSMutableArray alloc] init] autorelease];
		
		NSString *typeSummary = [self itemizationTypeSummary:sourceForTax
			andPrefix:LOCALIZED_STR(@"INPUT_TAX_ITEMIZATION_SUMMARY_SOURCE")];
		if(typeSummary != nil) { [typeSummmaryList addObject:typeSummary]; }
		
		typeSummary = [self itemizationTypeSummary:deductionForTax
			andPrefix:LOCALIZED_STR(@"INPUT_TAX_ITEMIZATION_SUMMARY_DEDUCTION")];
		if(typeSummary != nil) { [typeSummmaryList addObject:typeSummary]; }
		
		typeSummary = [self itemizationTypeSummary:adjustmentForTax
			andPrefix:LOCALIZED_STR(@"INPUT_TAX_ITEMIZATION_SUMMARY_ADJUSTMENT")];
		if(typeSummary != nil) { [typeSummmaryList addObject:typeSummary]; }

		typeSummary = [self itemizationTypeSummary:creditForTax
			andPrefix:LOCALIZED_STR(@"INPUT_TAX_ITEMIZATION_SUMMARY_CREDIT")];
		if(typeSummary != nil) { [typeSummmaryList addObject:typeSummary]; }
		
		if(typeSummmaryList.count>0)
		{
			summary = [typeSummmaryList componentsJoinedByString:@"  "];
		}
		
						
	}
	return summary;
}

-(StaticNavFieldEditInfo*)createItemizedTaxSelectionFieldEditInfoWithFieldLabel:(NSString*)fieldLabel
	andFormInfoCreator:(id<FormInfoCreator>)formInfoCreator
	andItemizedTaxAmtsInfo:(NSSet*)itemizedTaxAmts
{
	MultipleSelectionTableViewControllerFactory *taxSelectionTableViewFactory = 
			[[[MultipleSelectionTableViewControllerFactory alloc] 
			initWithFormInfoCreator:formInfoCreator] autorelease];
			
			
	NSString *subTitle = [self itemizationSummaryForItemizedTaxAmtsInfo:itemizedTaxAmts];
	
	NSString *itemizationDescription = nil;
	if(subTitle == nil)
	{
		// If the subtitle is nil, then there aren't any itemizations for the input
		// In this case, at least display a caption for there not being any itemizations.
		// If the subtitle is not nil, then the actual itemizations can be listed.
		itemizationDescription =
			LOCALIZED_STR(@"ITEMIZED_TAX_NO_ITEMIZATIONS_FOR_INPUT_CONTENT_DESCRIPTION");
	}
	
	assert([StringValidation nonEmptyString:fieldLabel]);
	StaticNavFieldEditInfo *taxesFieldEditInfo = [[[StaticNavFieldEditInfo alloc]
			initWithCaption:fieldLabel
			andSubtitle:subTitle andContentDescription:itemizationDescription
			andSubViewFactory:taxSelectionTableViewFactory] autorelease];
			
	return taxesFieldEditInfo;
	
	[self.currentSection addFieldEditInfo:taxesFieldEditInfo];

}


-(void)populateItemizedTaxSelectionWithFieldLabel:(NSString*)fieldLabel
	andFormInfoCreator:(id<FormInfoCreator>)formInfoCreator
	andItemizedTaxAmtsInfo:(NSSet*)itemizedTaxAmts
{

	StaticNavFieldEditInfo *fieldEditInfo =
		[self createItemizedTaxSelectionFieldEditInfoWithFieldLabel:fieldLabel andFormInfoCreator:formInfoCreator andItemizedTaxAmtsInfo:itemizedTaxAmts];
		
	[self.currentSection addFieldEditInfo:fieldEditInfo];

}

-(void)populateItemizedTaxSelectionWithFieldLabel:(NSString*)fieldLabel
	andFormInfoCreator:(id<FormInfoCreator>)formInfoCreator
	andItemizedTaxAmtsInfo:(NSSet*)itemizedTaxAmts
	andShowHideCondition:(id<FieldShowHideCondition>)showHideCondition
{

	StaticNavFieldEditInfo *fieldEditInfo =
		[self createItemizedTaxSelectionFieldEditInfoWithFieldLabel:fieldLabel andFormInfoCreator:formInfoCreator andItemizedTaxAmtsInfo:itemizedTaxAmts];
		
	[self.currentSection addConditionallyShownFieldEditInfo:fieldEditInfo withShowHideCondition:showHideCondition];

}

-(void)populateItemizedTaxSelectionWithFieldLabel:(NSString*)fieldLabel
	andItemizedTaxAmtsFormInfoCreator:(ItemizedTaxAmtsSelectionFormInfoCreator *)formInfoCreator
{
	MultipleSelectionTableViewControllerFactory *taxSelectionTableViewFactory = 
			[[[MultipleSelectionTableViewControllerFactory alloc] 
			initWithFormInfoCreator:formInfoCreator] autorelease];

	assert([StringValidation nonEmptyString:fieldLabel]);
	StaticNavFieldEditInfo *taxesFieldEditInfo = [[[StaticNavFieldEditInfo alloc]
			initWithCaption:fieldLabel
			andSubtitle:[formInfoCreator.itemizedTaxAmtsInfo itemizationSummary]
			andContentDescription:[formInfoCreator.itemizedTaxAmtsInfo itemizationCountSummary]
			andSubViewFactory:taxSelectionTableViewFactory] autorelease];
	[self.currentSection addFieldEditInfo:taxesFieldEditInfo];

}

-(void)populateAcctWithdrawalOrderField:(Account*)account
	andFieldCaption:(NSString*)caption andFieldSubtitle:(NSString*)subtitle
{
	AccountWithdrawalOrderInfo *withdrawalOrderInfo =
		[[[AccountWithdrawalOrderInfo alloc] initWithAccount:account
		andDataModelController:self.formContext.dataModelController
		andCurrentScenaro:self.inputScenario] autorelease];
	AccountWithdrawalOrderFieldEditInfo *withdrawalFieldEditInfo =
		[[[AccountWithdrawalOrderFieldEditInfo alloc]
			initWithAccountWithdrawalOrderInfo:withdrawalOrderInfo andCaption:caption andSubtitle:subtitle] autorelease];
	[self.currentSection addFieldEditInfo:withdrawalFieldEditInfo];

}

-(TableHeaderWithDisclosure*)scenarioListTableHeaderWithFormContext:(FormContext*)formContext
{
	SelectScenarioTableHeaderButtonDelegate *scenarioListDisclosureDelegate = 
			[[[SelectScenarioTableHeaderButtonDelegate alloc] 
			initWithFormContext:formContext] autorelease];
	TableHeaderWithDisclosure *tableHeader = 
			[[[TableHeaderWithDisclosure alloc] initWithFrame:CGRectZero 
				andDisclosureButtonDelegate:scenarioListDisclosureDelegate] autorelease];
	SharedAppValues *sharedAppVals = [SharedAppValues getUsingDataModelController:formContext.dataModelController];
	tableHeader.header.text = [NSString 
			stringWithFormat:LOCALIZED_STR(@"INPUT_CURRENT_SCENARIO_TABLE_HEADER_FORMAT"),
			sharedAppVals.currentInputScenario.scenarioName];
	[tableHeader resizeForChildren];
	return tableHeader;
}


-(void)dealloc
{
	[inputScenario release];
	[super dealloc];
}	

@end
