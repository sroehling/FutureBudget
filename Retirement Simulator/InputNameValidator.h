//
//  InputNameValidator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 3/6/13.
//
//

#import "TextFieldValidator.h"

@class Input;
@class DataModelController;

@interface InputNameValidator : TextFieldValidator
{
	@private
		Input *currentInput;
		NSMutableSet *otherInputNames;
}

@property(nonatomic,retain) Input *currentInput;
@property(nonatomic,retain) NSMutableSet *otherInputNames;

-(id)initWithInput:(Input *)theCurrentInput andDataModelController:(DataModelController*)theDmc;

@end
