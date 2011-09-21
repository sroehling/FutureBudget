//
//  DataModelInterface.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DataModelInterface <NSObject>

- (id)createDataModelObject:(NSString*)entityName;

@end
