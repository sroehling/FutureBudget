//
//  DetailInputViewCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InputVisitor.h"


@interface DetailInputViewCreator : NSObject <InputVisitor> {
    UIViewController *detailViewController;
}

@property (nonatomic,retain)UIViewController *detailViewController;

@end
