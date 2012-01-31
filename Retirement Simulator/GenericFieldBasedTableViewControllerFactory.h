//
//  GenericFieldBasedTableViewControllerFactory.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericTableViewFactory.h"

@protocol FormInfoCreator;

@interface GenericFieldBasedTableViewControllerFactory: NSObject <GenericTableViewFactory> {
    @private
		id<FormInfoCreator> formInfoCreator;
}


@property(nonatomic,retain) id<FormInfoCreator> formInfoCreator;

-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator;
@end
