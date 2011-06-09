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

// Advance to the next section, allocating a default SectionInfo Object
- (SectionInfo*) nextSection;

// Advance to the next section, using a custom 
// SectionInfo object (derived from SectionInfo)
- (void)nextCustomSection:(SectionInfo*)customSection;

@end