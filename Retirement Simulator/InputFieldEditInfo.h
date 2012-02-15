//
//  InputFieldEditInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldEditInfo.h"

@class Input;
@class FormFieldWithSubtitleTableCell;
@class DataModelController;

@interface InputFieldEditInfo : NSObject <FieldEditInfo> {
    @private
		Input *input;
		FormFieldWithSubtitleTableCell *inputCell;
		DataModelController *dataModelController;
}

@property(nonatomic,retain) Input *input;
@property(nonatomic,retain) FormFieldWithSubtitleTableCell *inputCell;
@property(nonatomic,retain) DataModelController *dataModelController;


- (id)initWithInput:(Input*)theInput andDataModelController:(DataModelController*)dataModelController;

@end
