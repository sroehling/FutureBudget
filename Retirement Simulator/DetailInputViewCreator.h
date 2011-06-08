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
@class FormPopulator;


@interface DetailInputViewCreator : NSObject <InputVisitor,FormInfoCreator> {
    FormPopulator *formPopulator;
    Input *input;
}

@property(nonatomic,retain) Input *input;

-(id) initWithInput:(Input*)theInput;

@end
