//
//  InputTagNameFieldValidator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import <Foundation/Foundation.h>

#import "TextFieldValidator.h"

@class InputTag;
@class DataModelController;

@interface InputTagNameFieldValidator : TextFieldValidator
{
	@private
		InputTag *inputTag;
		DataModelController *dmcForTagList;
}

@property(nonatomic,retain) InputTag *inputTag;
@property(nonatomic,retain) DataModelController *dmcForTagList;

-(id)initWithTag:(InputTag*)theTag andDmc:(DataModelController*)theDmcForTagList;


@end
