//
//  DefaultScenarioFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StaticFieldEditInfo.h"

@class DefaultScenario;

@interface DefaultScenarioFieldEditInfo : StaticFieldEditInfo {
    @private
		DefaultScenario *defaultScenario;
}


-(id)initWithDefaultScen:(DefaultScenario*)defaultScen;

@property(nonatomic,retain) DefaultScenario *defaultScenario;

@end
