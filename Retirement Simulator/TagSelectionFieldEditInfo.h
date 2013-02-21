//
//  TagSelectionFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/20/13.
//
//

#import <Foundation/Foundation.h>
#import "StaticFieldEditInfo.h"

@class InputTag;

@interface TagSelectionFieldEditInfo : StaticFieldEditInfo
{
	@private
		InputTag *inputTag;
}

@property(nonatomic,retain) InputTag *inputTag;

-(id)initWithTag:(InputTag*)theTag;


@end
