//
//  UserScenarioFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"

@class UserScenario;
@class FormFieldWithSubtitleTableCell;

@interface UserScenarioFieldEditInfo : NSObject <FieldEditInfo> {
    @private
		UserScenario *userScen;
		FormFieldWithSubtitleTableCell *scenarioCell;
}

@property(nonatomic,retain) UserScenario *userScen;
@property(nonatomic,retain) FormFieldWithSubtitleTableCell *scenarioCell;

- (id)initWithUserScenario:(UserScenario*)theUserScen;

@end
