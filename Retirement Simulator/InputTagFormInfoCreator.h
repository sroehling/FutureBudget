//
//  InputTagFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/15/13.
//
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class InputTag;

@interface InputTagFormInfoCreator : NSObject <FormInfoCreator>
{
	@private
		InputTag *inputTag;
}

@property(nonatomic,retain) InputTag *inputTag;

-(id)initWithTag:(InputTag*)theTag;


@end
