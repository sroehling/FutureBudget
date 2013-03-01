//
//  InputTypeSelectionFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/13.
//
//

#import <Foundation/Foundation.h>
#import "FormInfoCreator.h"
#import "SelectableObjectCreationTableViewController.h"


@class DataModelController;
@class InputCreationHelper;

@interface InputTypeSelectionFormInfoCreator : NSObject <FormInfoCreator>
{
	@private
		DataModelController *dmcForNewInputs;
		id<ObjectSelectedForCreationDelegate> inputSelectedForCreationDelegate;
		InputCreationHelper *inputCreationHelper;
}

@property(nonatomic,retain) DataModelController *dmcForNewInputs;
@property(nonatomic,assign) id<ObjectSelectedForCreationDelegate> inputSelectedForCreationDelegate;
@property(nonatomic,retain) InputCreationHelper *inputCreationHelper;

-(id)initWithDmcForNewInputs:(DataModelController*)theDmcForNewInputs
	andInputSelectedForCreationDelegate:(id<ObjectSelectedForCreationDelegate>)theInputSelectedForCreationDelegate;

@end
