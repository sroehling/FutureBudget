//
//  ScenarioNameValidator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/7/13.
//
//

#import "TextFieldValidator.h"

@class DataModelController;
@class UserScenario;

@interface ScenarioNameValidator : TextFieldValidator
{
	@private
		UserScenario *currentScenario;
		NSMutableSet *otherScenarioNames;
}

@property(nonatomic,retain) UserScenario *currentScenario;
@property(nonatomic,retain) NSMutableSet *otherScenarioNames;

-(id)initWithScenario:(UserScenario *)theCurrentScenario
		andDataModelController:(DataModelController*)theDmc;


@end
