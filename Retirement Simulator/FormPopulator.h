//
//  FormPopulator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FormInfo;
@class SectionInfo;

@interface FormPopulator : NSObject {
    @private
        FormInfo *formInfo;
}

@property(nonatomic,retain) FormInfo *formInfo;

- (SectionInfo*) nextSection;

@end
