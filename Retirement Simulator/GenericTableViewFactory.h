//
//  GenericTableViewFactory.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FormContext;

@protocol GenericTableViewFactory <NSObject>

- (UIViewController*)createTableView:(FormContext*)parentContext;

@end
