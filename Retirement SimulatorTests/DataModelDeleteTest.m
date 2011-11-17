//
//  DataModelDeleteTest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 11/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataModelDeleteTest.h"

#import "SharedAppValues.h"
#import "MultiScenarioInputValue.h"
#import "DefaultScenario.h"
#import "InputCreationHelper.h"
#import "UserScenario.h"
#import "FixedValue.h"
#import "ScenarioValue.h"

#import "DataModelController.h"
#import "ExpenseInput.h"
#import "InputTypeSelectionInfo.h"
#import "ExpenseItemizedTaxAmt.h"
#import "ItemizedTaxAmts.h"


@implementation DataModelDeleteTest

@synthesize testAppVals;
@synthesize inputCreationHelper;
@synthesize coreDataInterface;


-(void)resetCoreData
{
/* Use the following to test with the 
   SQLite core data:
	self.coreDataInterface = [DataModelController theDataModelController];
	self.testAppVals = [SharedAppValues singleton];
*/

	self.coreDataInterface = [[[DataModelController alloc] initForInMemoryStorage] autorelease]; 
	self.testAppVals = [SharedAppValues createWithDataModelInterface:self.coreDataInterface];
	
	self.inputCreationHelper = [[[InputCreationHelper alloc] 
		initWithDataModelInterface:self.coreDataInterface
		andSharedAppVals:self.testAppVals] autorelease];

}

- (void)setUp
{
	[self resetCoreData];
}

- (void)tearDown
{
	[testAppVals release];
	[inputCreationHelper release];
}

-(void)checkObjectIsStored:(NSManagedObject*)obj withName:(NSString*)name andEntity:(NSString*)entityName
	andExpected:(BOOL)expectedInStore
{

    NSArray *results = [self.coreDataInterface fetchResults:entityName includePendingChanges:FALSE];	
	BOOL objInStore = [results containsObject:obj];
    NSString *objInStoreStr = objInStore?@"YES":@"NO";
	NSString *expectedStr = expectedInStore?@"YES":@"NO";
	
	NSLog(@"%@: Object in store? %@, expected = %@ (count = %d)",
		name,objInStoreStr,expectedStr,[results count]);
	STAssertEquals(objInStore, expectedInStore, @"%@: Object in store? %@, expected = %@ (count = %d)",
		name,objInStoreStr,expectedStr,[results count]);
	

}

-(void)checkSetCount:(NSSet*)theSet withExpected:(NSUInteger)expectedCount andLabel:(NSString*)label
{
	NSLog(@"Checking set count: %@: expecting = %d, got = %d",
		label,expectedCount,[theSet count]);
	STAssertEquals(expectedCount, [theSet count], @"Checking set count: %@: expecting = %d, got = %d",
		label,expectedCount,[theSet count]);
}

-(void)checkObj:(NSManagedObject*)obj inSet:(NSSet*)theSet andExpected:(BOOL)expectedInSet withLabel:(NSString*)label
{
	BOOL objInSet = [theSet containsObject:obj];
	
	NSString *objInSetStr = objInSet?@"YES":@"NO";
	NSString *expectedStr = expectedInSet?@"YES":@"NO";
	
	NSLog(@"Check set membership: %@: expecting = %@, got = %@",
		label,expectedStr,objInSetStr);
	STAssertEquals(objInSet, expectedInSet, @"Check set membership: %@: expecting = %@, got = %@",
		label,expectedStr,objInSetStr);
}

-(void)checkScenarioDefined:(Scenario*)theScen forInputVal:(MultiScenarioInputValue*)msInputVal 
	expected:(BOOL)expectedDefined withlabel:(NSString*)label
{
	InputValue *foundValue = [msInputVal findInputValueForScenario:theScen];
	NSString *foundStr = (foundValue == nil)?@"NO":@"YES";
	
	if(expectedDefined)
	{
		NSLog(@"%@: Scenario defined?: %@: expected to be defined = YES",label,foundStr);
		STAssertNotNil(foundValue, @"%@: Scenario defined?: %@: expected to be defined = YES",label,foundStr);
	}
	else
	{
		NSLog(@"%@: Scenario defined?: %@: expected to be defined = NO",label,foundStr);
		STAssertNil(foundValue, @"%@: Scenario defined?: %@: expected to be defined = YES",label,foundStr);
	}
}

-(void)checkValidDelete:(NSManagedObject*)obj expected:(BOOL)expectValid label:(NSString*)label
{
	NSError *error;
	BOOL canDelete = [obj validateForDelete:&error];
	
	if((!canDelete) && (canDelete != expectValid))
	{
		NSLog(@"checkValidDelete error: %@",[error description]);
	}
	
	NSString *expectedStr = expectValid?@"YES":@"NO";
	NSString *validStr = canDelete?@"YES":@"NO";
	
	NSLog(@"Valid delete? %@: expected = %@, got = %@",label,expectedStr,validStr);
	STAssertTrue(canDelete == expectValid, 
		@"Valid delete? %@: expected = %@, got = %@",label,expectedStr,validStr);

}


-(void)testSuccessfulDeleteWithScenarioAndCascadeToScenarioValue
{
	[self resetCoreData];

	NSLog(@"Test deletion of a custom/user scenario fails when the scenario is referenced as the"
		" current input scenario");
	
	UserScenario *customScenario = [self.coreDataInterface createDataModelObject:USER_SCENARIO_ENTITY_NAME];
		
	customScenario.name = @"Custom Scenario";
	[self checkValidDelete:customScenario expected:YES label:@"Custom Scenario just allocated"];

	ScenarioValue *scenVal = [self.coreDataInterface createDataModelObject:SCENARIO_VALUE_ENTITY_NAME];
	scenVal.scenario = customScenario;
	scenVal.inputValue = [inputCreationHelper fixedValueForValue:1.0];

	STAssertNoThrow([self.coreDataInterface saveContext], @"Save should succeed");

	[self checkObjectIsStored:customScenario withName:@"Custom Scenario" 
		andEntity:USER_SCENARIO_ENTITY_NAME andExpected:TRUE];
	[self checkObjectIsStored:scenVal withName:@"ScenarioValue" 
		andEntity:SCENARIO_VALUE_ENTITY_NAME andExpected:TRUE];


	[self.coreDataInterface deleteObject:customScenario];
	[self.coreDataInterface saveContext];
	
	[self checkObjectIsStored:customScenario withName:@"Custom Scenario" 
		andEntity:USER_SCENARIO_ENTITY_NAME andExpected:FALSE];
	[self checkObjectIsStored:scenVal withName:@"ScenarioValue" 
		andEntity:SCENARIO_VALUE_ENTITY_NAME andExpected:FALSE];

}


-(void)testFailedDeleteWithCurrentScenarioAndScenarioValue
{
	[self resetCoreData];

	NSLog(@"Test deletion of a custom/user scenario fails when the scenario is referenced as the"
		" current input scenario");
	
	UserScenario *customScenario = [self.coreDataInterface createDataModelObject:USER_SCENARIO_ENTITY_NAME];
		
	customScenario.name = @"Custom Scenario";

	ScenarioValue *scenVal = [self.coreDataInterface createDataModelObject:SCENARIO_VALUE_ENTITY_NAME];
	scenVal.scenario = customScenario;
	scenVal.inputValue = [inputCreationHelper fixedValueForValue:1.0];

	STAssertNoThrow([self.coreDataInterface saveContext], @"Save should succeed");

	[self checkObjectIsStored:customScenario withName:@"customScenario successfully saved" 
		andEntity:USER_SCENARIO_ENTITY_NAME andExpected:TRUE];
	[self checkObjectIsStored:scenVal withName:@"scenVal successfully saved" 
		andEntity:SCENARIO_VALUE_ENTITY_NAME andExpected:TRUE];
		
	self.testAppVals.currentInputScenario = customScenario;


	[self.coreDataInterface deleteObject:customScenario];
	STAssertThrows([self.coreDataInterface saveContext], @"Save should fail since customScenario referred to as currentInputScenario (with Deny delete rule");
	
	[self checkObjectIsStored:customScenario withName:@"customScenario still stored after failed delete" 
		andEntity:USER_SCENARIO_ENTITY_NAME andExpected:TRUE];
	[self checkObjectIsStored:scenVal withName:@"scenVal still stored after failed delete" 
		andEntity:SCENARIO_VALUE_ENTITY_NAME andExpected:TRUE];

}

-(void)testScenarioDelete
{
	[self resetCoreData];
	
	NSLog(@"Test deletion of a custom/user scenario cascades to delete any referencing ScenarioVals");
	MultiScenarioInputValue *valWithScenarioChange = [inputCreationHelper multiScenFixedValWithDefault:100.0];
	
	UserScenario *customScenario = [self.coreDataInterface createDataModelObject:USER_SCENARIO_ENTITY_NAME];
	customScenario.name = @"Custom Scenario";
	
	[valWithScenarioChange setValueForScenario:customScenario 
		andInputValue:[inputCreationHelper fixedValueForValue:200.0]];

	STAssertNoThrow([self.coreDataInterface saveContext], @"Save should succeed");
	
	[self checkSetCount:valWithScenarioChange.scenarioVals withExpected:2 andLabel:@"scenario vals"];
	[self checkObjectIsStored:customScenario withName:@"Custom Scenario" 
			andEntity:USER_SCENARIO_ENTITY_NAME andExpected:TRUE];
	[self checkScenarioDefined:customScenario forInputVal:valWithScenarioChange expected:TRUE withlabel:@"Custom"];
	[self checkScenarioDefined:self.testAppVals.defaultScenario 
		forInputVal:valWithScenarioChange expected:TRUE withlabel:@"Default"];

		
	// Deleting the scenario should cascade to delete the ScenaroValue
	[self.coreDataInterface deleteObject:customScenario];
	[self.coreDataInterface saveContext];
	
	[self checkSetCount:valWithScenarioChange.scenarioVals withExpected:1 andLabel:@"scenario vals"];
	[self checkObjectIsStored:customScenario withName:@"Custom Scenario" 
			andEntity:USER_SCENARIO_ENTITY_NAME andExpected:FALSE];
	[self checkScenarioDefined:customScenario forInputVal:valWithScenarioChange expected:FALSE withlabel:@"Custom"];
	[self checkScenarioDefined:self.testAppVals.defaultScenario forInputVal:valWithScenarioChange expected:TRUE withlabel:@"Default"];

}

-(void)testExpenseDeletesAssociatedItemizedTaxAmts
{
	[self resetCoreData];
	
	NSLog(@"Test that the deletion of an expense cascades to delete any associated ItemizedTaxAmts");
	ExpenseInputTypeSelectionInfo *expenseCreator = 
		[[[ExpenseInputTypeSelectionInfo alloc] initWithInputCreationHelper:self.inputCreationHelper andDataModelInterface:self.coreDataInterface] autorelease];
		
	ExpenseInput *expense = (ExpenseInput*)[expenseCreator createInput];
	expense.name = @"Test Expense";
	
	ExpenseItemizedTaxAmt *itemizedTaxAmt = [self.coreDataInterface createDataModelObject:EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME];
	itemizedTaxAmt.multiScenarioApplicablePercent = [self.inputCreationHelper multiScenFixedValWithDefault:100.0];
	itemizedTaxAmt.expense  = expense;
	
	[self checkSetCount:expense.expenseItemizedTaxAmts withExpected:1 
		andLabel:@"expense should have a link back to any ItemizedTaxAmt's"];
	
	ItemizedTaxAmts *itemizedTaxAmts = (ItemizedTaxAmts*)[self.coreDataInterface 
		createDataModelObject:ITEMIZED_TAX_AMTS_ENTITY_NAME];
	[itemizedTaxAmts addItemizedAmtsObject:itemizedTaxAmt];

	
	NSLog(@"Expense: %@",[expense description]);
	
	STAssertNoThrow([self.coreDataInterface saveContext], @"Save should succeed");
	
	
	[self.coreDataInterface deleteObject:expense];
	STAssertNoThrow([self.coreDataInterface saveContext], @"Save should succeed");

	[self checkSetCount:itemizedTaxAmts.itemizedAmts withExpected:0 andLabel:@"Deleting the expense should cascade to remove it from the itemizedTaxAmts collection of ItemizedTaxAmts object"];
	[self checkObjectIsStored:expense withName:@"Expense should be deleted" 
			andEntity:EXPENSE_INPUT_ENTITY_NAME andExpected:FALSE];
	[self checkObjectIsStored:itemizedTaxAmt withName:@"itemizedTaxAmt should be deleted" 
			andEntity:EXPENSE_ITEMIZED_TAX_AMT_ENTITY_NAME andExpected:FALSE];
		
	

}


@end
