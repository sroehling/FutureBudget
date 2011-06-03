//
//  FormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfo.h"

@protocol FormInfoCreator <NSObject>

- (FormInfo*)createFormInfo:(UIViewController*)parentController;

@end
