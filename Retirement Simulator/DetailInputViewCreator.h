//
//  DetailInputViewCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InputVisitor.h"
#import "FormInfoCreator.h"

@class Input;
@class InputFormPopulator;


@interface DetailInputViewCreator : NSObject <InputVisitor,FormInfoCreator> {
    InputFormPopulator *formPopulator;
    Input *input;
	BOOL isForNewObject;
}

@property(nonatomic,retain) Input *input;
@property BOOL isForNewObject;
@property(nonatomic,retain) InputFormPopulator *formPopulator;

-(id) initWithInput:(Input*)theInput andIsForNewObject:(BOOL)forNewObject;

@end
