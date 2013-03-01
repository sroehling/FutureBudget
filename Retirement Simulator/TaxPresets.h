//
//  TaxPresets.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 2/26/13.
//
//

#import <Foundation/Foundation.h>

@class DataModelController;
@class TaxInput;

extern NSString *const TAX_PRESET_PRESET_NAME_PLIST_KEY;
extern NSString *const TAX_PRESET_PRESET_DESCRIPTION_PLIST_KEY;
extern NSString *const TAX_PRESET_PRESET_IMAGE_PLIST_KEY;


@interface TaxPresets : NSObject

+(NSArray*)loadPresetList;
+(void)populateTaxInputWithPresetInfo:(TaxInput*)taxInput presetInfo:(NSDictionary*)presetPlistInfo
	andDataModelController:(DataModelController*)dmcForPresetInputCreation;

@end
