//
//  UserScenarioFormInfoCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FormInfoCreator.h"

@class UserScenario;

@interface UserScenarioFormInfoCreator : NSObject <FormInfoCreator> {
    @private
		UserScenario *userScen;
        BOOL editNameAsFirstResponder; // optional - default is FALSE
}

@property(nonatomic,retain) UserScenario *userScen;
@property BOOL editNameAsFirstResponder;

-(id)initWithUserScenario:(UserScenario*)theScenario;

@end
