//
//  GenericFieldBasedTableEditViewControllerFactory.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 10/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericTableViewFactory.h"

@protocol FormInfoCreator;

@interface GenericFieldBasedTableEditViewControllerFactory : NSObject <GenericTableViewFactory> {
    @private
		id<FormInfoCreator> formInfoCreator;
}


@property(nonatomic,retain) id<FormInfoCreator> formInfoCreator;

-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator;

@end
