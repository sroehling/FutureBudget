//
//  InputTagSelectionFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import <Foundation/Foundation.h>

#import "StaticFieldEditInfo.h"

@class Input;
@class InputTag;

@interface InputTagSelectionFieldEditInfo : StaticFieldEditInfo
{
	@private
		Input *inputBeingTagged;
		InputTag *inputTag;
}

@property(nonatomic,retain) InputTag *inputTag;
@property(nonatomic,retain) Input *inputBeingTagged;

-(id)initWithInput:(Input*)theInput andTag:(InputTag*)theTag;

@end
