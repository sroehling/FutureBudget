//
//  InputTypeSelectionFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/13.
//
//

#import <Foundation/Foundation.h>
#import "FormInfoCreator.h"

@class DataModelController;

@interface InputTypeSelectionFormInfoCreator : NSObject <FormInfoCreator>
{
	@private
		DataModelController *dmcForNewInputs;
}

@property(nonatomic,retain) DataModelController *dmcForNewInputs;

-(id)initWithDmcForNewInputs:(DataModelController*)theDmcForNewInputs;

@end
