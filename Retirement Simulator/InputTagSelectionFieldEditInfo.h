//
//  InputTagSelectionFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import <Foundation/Foundation.h>

#import "TagSelectionFieldEditInfo.h"

@class Input;
@class InputTag;

@interface InputTagSelectionFieldEditInfo : TagSelectionFieldEditInfo
{
	@private
		Input *inputBeingTagged;
}

@property(nonatomic,retain) Input *inputBeingTagged;

-(id)initWithInput:(Input*)theInput andTag:(InputTag*)theTag;

@end
