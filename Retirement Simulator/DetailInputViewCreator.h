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
@class FormContext;
@class DateHelper;


@interface DetailInputViewCreator : NSObject <InputVisitor,FormInfoCreator> {
    @private
        InputFormPopulator *formPopulator;
        FormContext *formContext;
        Input *input;
        BOOL isForNewObject;
        DateHelper *dateHelper;
}

@property(nonatomic,retain) Input *input;
@property BOOL isForNewObject;
@property(nonatomic,retain) InputFormPopulator *formPopulator;
@property(nonatomic,retain) FormContext *formContext;
@property(nonatomic,retain) DateHelper *dateHelper;

-(id) initWithInput:(Input*)theInput andIsForNewObject:(BOOL)forNewObject;

@end
