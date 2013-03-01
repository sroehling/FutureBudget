//
//  TaxInputTypeSelectionInfo.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/28/13.
//
//

#import <Foundation/Foundation.h>

#import "InputTypeSelectionInfo.h"

@class DataModelController;

@interface TaxInputTypeSelectionInfo : InputTypeSelectionInfo {
	@private
		NSDictionary *presetPlistInfo;
}

@property(nonatomic,retain) NSDictionary *presetPlistInfo;

-(id)initWithInputCreationHelper:(InputCreationHelper *)theHelper
	andDataModelController:(DataModelController*)theDataModelController;

-(id)initWithInputCreationHelper:(InputCreationHelper*)theHelper 
	andDataModelController:(DataModelController*)theDataModelController
	andPresetPlistInfo:(NSDictionary*)thePresetInfo;

@end
