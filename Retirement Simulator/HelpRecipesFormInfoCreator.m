//
//  HelpRecipesFormInfoCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HelpRecipesFormInfoCreator.h"

#import "LocalizationHelper.h"
#import "SectionInfo.h"
#import "StaticNavFieldEditInfo.h"
#import "HelpViewFactory.h"
#import "HelpPageInfo.h"
#import "HelpPageFormPopulator.h"

@implementation HelpRecipesFormInfoCreator


- (FormInfo*)createFormInfo:(UIViewController*)parentController
{
    HelpPageFormPopulator *formPopulator = [[[HelpPageFormPopulator alloc] 
		initWithParentController:parentController] autorelease];
    
    formPopulator.formInfo.title = LOCALIZED_STR(@"MORE_RECIPES_TITLE");
	
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"HELP_RECIPES_INCOME_EXPENSE_SECTION_TITLE")];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_MONTHLY_EXPENSE") andPageRef:@"recipeMonthlyExpense"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_EMPLOYMENT_INCOME") andPageRef:@"recipeEmploymentIncome"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_WINDFALL") andPageRef:@"recipeWindfall"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_WEDDING") andPageRef:@"recipeWedding"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_CUT_EXPENSE") andPageRef:@"recipeCuttingExpense"];
			
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"HELP_RECIPES_HOUSING_SECTION_TITLE")];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_EXISTING_HOUSE") andPageRef:@"recipeExistingHouse"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_NEW_HOUSE") andPageRef:@"recipeNewHouse"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_VACATION_HOUSE") andPageRef:@"recipeVacationHouse"];
	// TBD - Should we add a recipe for home remodeling.

	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"HELP_RECIPES_AUTO_SECTION_TITLE")];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_EXISTING_VEHICLE") andPageRef:@"recipeExistingVehicle"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_NEW_CAR") andPageRef:@"recipeNewCar"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_LEASE_CAR") andPageRef:@"recipeLeaseCar"];

	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"HELP_RECIPES_INVEST_SECTION_TITLE")];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_INVEST_SAVINGS") andPageRef:@"recipeRegularSavings"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_INVEST_401K") andPageRef:@"recipeInvestment401K"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_INVEST_ROTHIRA") andPageRef:@"recipeInvestmentRothIRA"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_INVEST_BROKERAGE") andPageRef:@"recipeInvestmentBrokerage"];
				
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"HELP_RECIPES_HEALTH_SECTION_TITLE")];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_MEDICAL_EXPENSE_TITLE") andPageRef:@"recipeMedicalExpense"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_HSA_TITLE") andPageRef:@"recipeHSA"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_HEALTH_INFLATION_TITLE") andPageRef:@"recipeHealthInflation"];
			
	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"HELP_RECIPES_EDUCATION_SECTION_TITLE")];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_COLLEGE_EXPENSE") andPageRef:@"recipeCollegeExpenses"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_COLLEGE_SAVINGS") andPageRef:@"recipeCollegeSavings"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_STUDENT_LOAN") andPageRef:@"recipeStudentLoan"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_BACK_TO_SCHOOL") andPageRef:@"recipeBackToSchool"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_COLLEGE_INFLATION") andPageRef:@"recipeCollegeInflation"];

	[formPopulator nextSectionWithTitle:LOCALIZED_STR(@"HELP_RECIPES_RETIRE_SECTION_TITLE")];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_RETIRE_CHANGE_EXPENSE") andPageRef:@"recipeChangeRetirementExpense"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_RETIRE_SEMIRETIRE") andPageRef:@"recipeSemiRetirement"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_RETIRE_CONSERVATIVE_INVEST") andPageRef:@"recipeInvestConservative"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_RETIRE_SSINCOME") andPageRef:@"recipeSocialSecurityIncome"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_RETIRE_PENSION_INCOME") andPageRef:@"recipePensionIncome"];
	[formPopulator populateHelpPageWithTitle:
		LOCALIZED_STR(@"HELP_RECIPE_RETIRE_DOWNSIZE_HOUSE") andPageRef:@"recipeDownsizeHouse"];
					
	return formPopulator.formInfo;
	
}


@end
