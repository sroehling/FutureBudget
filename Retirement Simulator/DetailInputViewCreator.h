//
//  DetailInputViewCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InputVisitor.h"
@class Input;


@interface DetailInputViewCreator : NSObject <InputVisitor> {
    NSMutableArray *detailFieldEditInfo;
}

@property (nonatomic,retain)NSMutableArray *detailFieldEditInfo;


- (UIViewController *)createDetailViewForInput:(Input*)input;
- (UIViewController *)createAddViewForInput:(Input *)input;

@end
