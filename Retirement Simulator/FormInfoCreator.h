//
//  FormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfo.h"

@class FormContext;

@protocol FormInfoCreator <NSObject>

- (FormInfo*)createFormInfoWithContext:(FormContext*)parentContext;

@end
