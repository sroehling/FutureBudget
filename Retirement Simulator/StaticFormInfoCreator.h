//
//  StaticFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FormInfo;
#import "FormInfoCreator.h"

@interface StaticFormInfoCreator : NSObject <FormInfoCreator> {
    @private
    FormInfo *formInfo;
}

@property(nonatomic,retain) FormInfo *formInfo;

- (id) initWithFormInfo:(FormInfo*)theFormInfo;
+ (StaticFormInfoCreator*)createWithFormInfo:(FormInfo*)theFormInfo;

@end
