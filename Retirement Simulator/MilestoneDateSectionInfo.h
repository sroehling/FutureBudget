//
//  MilestoneDateSectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SectionInfo.h"

@interface MilestoneDateSectionInfo : SectionInfo {
@private
    UIViewController *parentViewController;
}

// This property is setup as a weak/assign reference,
// since the parent view controller will likely have an
// indirect link to this section info, so, we don't want
// to create a circular reference that would be problematic
// with reference counting.
@property(nonatomic,assign) UIViewController *parentViewController;


@end
