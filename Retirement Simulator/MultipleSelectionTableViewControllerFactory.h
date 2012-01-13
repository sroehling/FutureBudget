//
//  MultipleSelectionTableViewControllerFactory.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 1/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericTableViewFactory.h"
#import "FormInfoCreator.h"

@interface MultipleSelectionTableViewControllerFactory : NSObject <GenericTableViewFactory> {
    @private
		id<FormInfoCreator> formInfoCreator;
}


@property(nonatomic,retain) id<FormInfoCreator> formInfoCreator;

-(id)initWithFormInfoCreator:(id<FormInfoCreator>)theFormInfoCreator;

@end
